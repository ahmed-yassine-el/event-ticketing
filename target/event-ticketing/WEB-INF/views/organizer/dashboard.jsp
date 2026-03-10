<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Organizer Dashboard"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .organizer-dashboard {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .organizer-dashboard .glass-panel,
    .organizer-dashboard .metric-card {
        border-radius: 1.15rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 24px 42px rgba(6, 7, 19, 0.4);
    }

    .organizer-dashboard .metric-card {
        padding: 1rem;
        min-height: 122px;
    }

    .organizer-dashboard .metric-label {
        margin: 0;
        font-size: 0.76rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(216, 220, 248, 0.72);
    }

    .organizer-dashboard .metric-value {
        margin: 0.45rem 0 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.45rem, 3.2vw, 2rem);
        line-height: 1.08;
        color: #F9FAFF;
    }

    .organizer-dashboard .metric-card.primary {
        background: linear-gradient(135deg, rgba(124, 58, 237, 0.32), rgba(37, 99, 235, 0.2));
    }

    .organizer-dashboard .metric-card.success {
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.24), rgba(37, 99, 235, 0.2));
    }

    .organizer-dashboard .metric-card.dark {
        background: linear-gradient(135deg, rgba(17, 24, 39, 0.45), rgba(236, 72, 153, 0.2));
    }

    .organizer-dashboard .section-head {
        margin: 1.2rem 0 0.95rem;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 0.8rem;
        flex-wrap: wrap;
    }

    .organizer-dashboard .section-title {
        margin: 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.45rem, 3.2vw, 2rem);
        line-height: 1.08;
        background: linear-gradient(112deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .organizer-dashboard .btn-vivid,
    .organizer-dashboard .btn-soft,
    .organizer-dashboard .btn-danger-soft {
        border: 0;
        border-radius: 0.8rem;
        min-height: 36px;
        padding: 0.42rem 0.75rem;
        font-size: 0.82rem;
        font-weight: 700;
        letter-spacing: 0.01em;
        transition: transform 0.22s ease, box-shadow 0.22s ease;
    }

    .organizer-dashboard .btn-vivid {
        color: #FFFFFF;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 14px 28px rgba(124, 58, 237, 0.3);
    }

    .organizer-dashboard .btn-vivid:hover {
        transform: translateY(-1px);
        box-shadow: 0 18px 30px rgba(236, 72, 153, 0.34);
        color: #FFFFFF;
    }

    .organizer-dashboard .btn-soft {
        color: #EDE7FF;
        background: rgba(124, 58, 237, 0.2);
        border: 1px solid rgba(124, 58, 237, 0.7);
    }

    .organizer-dashboard .btn-soft:hover {
        color: #FFFFFF;
        background: rgba(124, 58, 237, 0.32);
        transform: translateY(-1px);
    }

    .organizer-dashboard .btn-danger-soft {
        color: #FFE2E8;
        background: rgba(239, 68, 68, 0.2);
        border: 1px solid rgba(248, 113, 113, 0.68);
    }

    .organizer-dashboard .btn-danger-soft:hover {
        color: #FFFFFF;
        background: rgba(239, 68, 68, 0.32);
        transform: translateY(-1px);
    }

    .organizer-dashboard .glass-panel {
        overflow: hidden;
    }

    .organizer-dashboard .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        overflow: hidden;
        background: rgba(8, 10, 24, 0.58);
    }

    .organizer-dashboard .event-table {
        margin: 0;
        --bs-table-bg: transparent;
        --bs-table-color: #EEF0FF;
        color: #EEF0FF;
    }

    .organizer-dashboard .event-table thead th {
        background: rgba(255, 255, 255, 0.04);
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        color: rgba(214, 219, 246, 0.78);
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        white-space: nowrap;
    }

    .organizer-dashboard .event-table td,
    .organizer-dashboard .event-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.8rem 0.7rem;
        vertical-align: middle;
    }

    .organizer-dashboard .status-pill {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.25rem 0.65rem;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 0.04em;
    }

    .organizer-dashboard .status-approved {
        background: rgba(34, 197, 94, 0.22);
        border-color: rgba(34, 197, 94, 0.58);
        color: #D6FFE3;
    }

    .organizer-dashboard .status-pending {
        background: rgba(245, 158, 11, 0.22);
        border-color: rgba(251, 191, 36, 0.62);
        color: #FFF1CB;
    }

    .organizer-dashboard .status-cancelled {
        background: rgba(239, 68, 68, 0.22);
        border-color: rgba(248, 113, 113, 0.62);
        color: #FFDCE3;
    }

    .organizer-dashboard .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 0.45rem;
    }

    .organizer-dashboard .actions form {
        margin: 0;
    }

    @media (max-width: 991.98px) {
        .organizer-dashboard .table-wrap {
            overflow-x: auto;
        }

        .organizer-dashboard .event-table {
            min-width: 900px;
        }
    }
</style>

<section class="organizer-dashboard">
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="metric-card kpi-card primary">
                <p class="metric-label">Total Events</p>
                <h3 class="metric-value"><c:out value="${totalEvents}"/></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="metric-card kpi-card success">
                <p class="metric-label">Total Tickets Sold</p>
                <h3 class="metric-value"><c:out value="${totalSold}"/></h3>
            </div>
        </div>
        <div class="col-md-4">
            <div class="metric-card kpi-card dark">
                <p class="metric-label">Estimated Revenue</p>
                <h3 class="metric-value"><fmt:formatNumber value="${estimatedRevenue}" type="currency"/></h3>
            </div>
        </div>
    </div>

    <div class="section-head">
        <h1 class="section-title">My Events</h1>
        <a class="btn-vivid" href="${pageContext.request.contextPath}/organizer/create-event">Create Event</a>
    </div>

    <div class="glass-panel">
        <div class="table-wrap table-responsive">
            <table class="table table-bordered align-middle event-table">
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Tickets</th>
                    <th>Price</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${events}" var="event">
                    <tr>
                        <td><c:out value="${event.title}"/></td>
                        <td><c:out value="${event.eventDate}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${event.status.name() == 'APPROVED'}"><span class="status-pill status-approved">APPROVED</span></c:when>
                                <c:when test="${event.status.name() == 'PENDING'}"><span class="status-pill status-pending">PENDING</span></c:when>
                                <c:otherwise><span class="status-pill status-cancelled">CANCELLED</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td><c:out value="${event.availableTickets}"/> / <c:out value="${event.totalTickets}"/></td>
                        <td><fmt:formatNumber value="${event.price}" type="currency"/></td>
                        <td>
                            <div class="actions">
                                <a class="btn-soft" href="${pageContext.request.contextPath}/organizer/edit-event?id=${event.id}">Edit</a>
                                <form method="post" action="${pageContext.request.contextPath}/organizer/delete-event">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="id" value="${event.id}">
                                    <button class="btn-danger-soft" type="submit">Delete</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
