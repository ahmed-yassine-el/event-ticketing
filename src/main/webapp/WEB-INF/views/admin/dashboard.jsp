<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin Dashboard"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-dashboard {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .admin-dashboard .metric-card,
    .admin-dashboard .glass-card {
        border-radius: 1.2rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 26px 44px rgba(7, 8, 20, 0.4);
        height: 100%;
    }

    .admin-dashboard .metric-card {
        padding: 0.95rem;
    }

    .admin-dashboard .metric-label {
        margin: 0;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(215, 220, 248, 0.74);
    }

    .admin-dashboard .metric-value {
        margin: 0.42rem 0 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.35rem, 3vw, 1.95rem);
        line-height: 1.1;
        color: #F8F9FF;
    }

    .admin-dashboard .metric-card.primary {
        background: linear-gradient(135deg, rgba(124, 58, 237, 0.3), rgba(37, 99, 235, 0.2));
    }

    .admin-dashboard .metric-card.info {
        background: linear-gradient(135deg, rgba(37, 99, 235, 0.3), rgba(14, 165, 233, 0.2));
    }

    .admin-dashboard .metric-card.warning {
        background: linear-gradient(135deg, rgba(245, 158, 11, 0.3), rgba(251, 191, 36, 0.2));
    }

    .admin-dashboard .metric-card.success {
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.28), rgba(37, 99, 235, 0.2));
    }

    .admin-dashboard .glass-card .card-body {
        padding: 1.1rem;
    }

    .admin-dashboard .section-title {
        margin: 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.2rem, 3vw, 1.5rem);
        color: #F7F8FF;
    }

    .admin-dashboard .btn-subtle,
    .admin-dashboard .btn-approve,
    .admin-dashboard .btn-reject {
        border: 0;
        border-radius: 0.78rem;
        min-height: 34px;
        padding: 0.38rem 0.7rem;
        font-size: 0.79rem;
        font-weight: 700;
        transition: transform 0.2s ease, background-color 0.2s ease;
    }

    .admin-dashboard .btn-subtle {
        color: #ECE7FF;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        background: rgba(124, 58, 237, 0.24);
        border: 1px solid rgba(124, 58, 237, 0.66);
    }

    .admin-dashboard .btn-subtle:hover {
        color: #FFFFFF;
        background: rgba(124, 58, 237, 0.36);
        transform: translateY(-1px);
    }

    .admin-dashboard .btn-approve {
        color: #E0FFE8;
        background: rgba(34, 197, 94, 0.24);
        border: 1px solid rgba(34, 197, 94, 0.6);
    }

    .admin-dashboard .btn-approve:hover {
        color: #FFFFFF;
        background: rgba(34, 197, 94, 0.34);
        transform: translateY(-1px);
    }

    .admin-dashboard .btn-reject {
        color: #FFE2E8;
        background: rgba(239, 68, 68, 0.24);
        border: 1px solid rgba(248, 113, 113, 0.66);
    }

    .admin-dashboard .btn-reject:hover {
        color: #FFFFFF;
        background: rgba(239, 68, 68, 0.34);
        transform: translateY(-1px);
    }

    .admin-dashboard .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        overflow: hidden;
        background: rgba(8, 10, 24, 0.58);
    }

    .admin-dashboard .pending-table {
        margin: 0;
        --bs-table-bg: transparent;
        --bs-table-striped-bg: rgba(255, 255, 255, 0.04);
        --bs-table-striped-color: #EDF0FF;
        color: #EDF0FF;
    }

    .admin-dashboard .pending-table thead th {
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        color: rgba(215, 220, 248, 0.78);
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        white-space: nowrap;
    }

    .admin-dashboard .pending-table td,
    .admin-dashboard .pending-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.78rem 0.7rem;
        vertical-align: middle;
    }

    .admin-dashboard .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 0.45rem;
    }

    .admin-dashboard .actions form {
        margin: 0;
    }

    @media (max-width: 991.98px) {
        .admin-dashboard .table-wrap {
            overflow-x: auto;
        }

        .admin-dashboard .pending-table {
            min-width: 860px;
        }
    }
</style>

<section class="admin-dashboard">
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="metric-card kpi-card primary">
                <p class="metric-label">Users</p>
                <h3 class="metric-value"><c:out value="${summary.totalUsers}"/></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card kpi-card info">
                <p class="metric-label">Events</p>
                <h3 class="metric-value"><c:out value="${summary.totalEvents}"/></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card kpi-card warning">
                <p class="metric-label">Tickets</p>
                <h3 class="metric-value"><c:out value="${summary.totalTickets}"/></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="metric-card kpi-card success">
                <p class="metric-label">Revenue</p>
                <h3 class="metric-value"><fmt:formatNumber value="${summary.totalRevenue}" type="currency"/></h3>
            </div>
        </div>
    </div>

    <div class="glass-card card">
        <div class="card-body">
            <div class="d-flex justify-content-between mb-3 flex-wrap gap-2 align-items-center">
                <h1 class="section-title">Pending Event Approvals</h1>
                <a href="${pageContext.request.contextPath}/admin/stats" class="btn-subtle">View Full Stats</a>
            </div>
            <div class="table-wrap table-responsive">
                <table class="table table-striped align-middle pending-table">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Organizer</th>
                        <th>Date</th>
                        <th>Location</th>
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
                            <td>
                                <div class="actions">
                                    <form action="${pageContext.request.contextPath}/admin/approve-event" method="post">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="id" value="${event.id}">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn-approve">Approve</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/admin/approve-event" method="post">
                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                        <input type="hidden" name="id" value="${event.id}">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn-reject">Reject</button>
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
