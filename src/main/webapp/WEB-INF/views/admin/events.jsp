<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Manage Events"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-events {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .admin-events .glass-card {
        border-radius: 1.2rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 26px 44px rgba(7, 8, 20, 0.4);
    }

    .admin-events .glass-card .card-body {
        padding: 1.1rem;
    }

    .admin-events .section-title {
        margin: 0 0 0.95rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.3rem, 3vw, 1.8rem);
        line-height: 1.1;
        color: #F7F8FF;
    }

    .admin-events .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        overflow: hidden;
        background: rgba(8, 10, 24, 0.58);
    }

    .admin-events .events-table {
        margin: 0;
        --bs-table-bg: transparent;
        color: #EDF0FF;
    }

    .admin-events .events-table thead th {
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        color: rgba(215, 220, 248, 0.78);
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        white-space: nowrap;
    }

    .admin-events .events-table td,
    .admin-events .events-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.78rem 0.68rem;
        vertical-align: middle;
    }

    .admin-events .status-pill {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(251, 191, 36, 0.62);
        background: rgba(245, 158, 11, 0.24);
        color: #FFF1CC;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 0.04em;
        padding: 0.24rem 0.6rem;
    }

    .admin-events .actions {
        display: flex;
        gap: 0.45rem;
        flex-wrap: wrap;
    }

    .admin-events .actions form {
        margin: 0;
    }

    .admin-events .btn-approve,
    .admin-events .btn-reject {
        border: 0;
        border-radius: 0.78rem;
        min-height: 34px;
        padding: 0.38rem 0.7rem;
        font-size: 0.79rem;
        font-weight: 700;
        transition: transform 0.2s ease, background-color 0.2s ease;
    }

    .admin-events .btn-approve {
        color: #E0FFE8;
        background: rgba(34, 197, 94, 0.24);
        border: 1px solid rgba(34, 197, 94, 0.6);
    }

    .admin-events .btn-approve:hover {
        color: #FFFFFF;
        background: rgba(34, 197, 94, 0.34);
        transform: translateY(-1px);
    }

    .admin-events .btn-reject {
        color: #FFE2E8;
        background: rgba(239, 68, 68, 0.24);
        border: 1px solid rgba(248, 113, 113, 0.66);
    }

    .admin-events .btn-reject:hover {
        color: #FFFFFF;
        background: rgba(239, 68, 68, 0.34);
        transform: translateY(-1px);
    }

    @media (max-width: 991.98px) {
        .admin-events .table-wrap {
            overflow-x: auto;
        }

        .admin-events .events-table {
            min-width: 980px;
        }
    }
</style>

<section class="admin-events">
    <div class="glass-card card">
        <div class="card-body">
            <h1 class="section-title">Approve or Reject Events</h1>
            <div class="table-wrap table-responsive">
                <table class="table table-bordered align-middle events-table">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Organizer</th>
                        <th>Date</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${pendingEvents}" var="event">
                        <tr>
                            <td><c:out value="${event.title}"/></td>
                            <td><c:out value="${event.organizer.name}"/></td>
                            <td><c:out value="${event.eventDate}"/></td>
                            <td><c:out value="${event.location}"/></td>
                            <td><fmt:formatNumber value="${event.price}" type="currency"/></td>
                            <td><span class="status-pill"><c:out value="${event.status}"/></span></td>
                            <td>
                                <div class="actions">
                                    <form method="post" action="${pageContext.request.contextPath}/admin/approve-event">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="id" value="${event.id}">
                                        <input type="hidden" name="action" value="approve">
                                        <button class="btn-approve" type="submit">Approve</button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/admin/approve-event">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="id" value="${event.id}">
                                        <input type="hidden" name="action" value="reject">
                                        <button class="btn-reject" type="submit">Reject</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
