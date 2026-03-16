<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Organizer Dashboard"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .section-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.8rem;
        flex-wrap: wrap;
        margin-bottom: 0.75rem;
    }

    .section-title {
        margin: 0;
        font-size: clamp(1.7rem, 3vw, 2.3rem);
    }

    .glass-panel {
        padding: 0.8rem;
    }

    .event-table td,
    .event-table th {
        white-space: nowrap;
    }

    .event-table td:first-child,
    .event-table th:first-child {
        white-space: normal;
        min-width: 200px;
    }
</style>

<section class="organizer-dashboard dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Organizer</h2>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/create-event">Create Event</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="row g-3 mb-4">
            <div class="col-md-4">
                <div class="metric-card kpi-card primary">
                    <p class="metric-label">Total Events</p>
                    <h3 class="metric-value"><c:out value="${totalEvents}"/></h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="metric-card kpi-card info">
                    <p class="metric-label">Total Tickets Sold</p>
                    <h3 class="metric-value"><c:out value="${totalSold}"/></h3>
                </div>
            </div>
            <div class="col-md-4">
                <div class="metric-card kpi-card success">
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
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
