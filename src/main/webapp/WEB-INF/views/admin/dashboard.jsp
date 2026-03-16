<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin Dashboard"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .pending-table td,
    .pending-table th {
        white-space: nowrap;
    }

    .pending-table td:first-child,
    .pending-table th:first-child {
        white-space: normal;
        min-width: 190px;
    }

    .section-title {
        margin: 0;
        font-size: clamp(1.7rem, 3vw, 2.3rem);
    }
</style>

<section class="admin-dashboard dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Admin</h2>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/events">Events</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
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

        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between mb-3 flex-wrap gap-2 align-items-center">
                    <h1 class="section-title">Pending Event Approvals</h1>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/admin/events" class="btn-subtle">Manage Events</a>
                        <a href="${pageContext.request.contextPath}/admin/stats" class="btn-subtle">View Full Stats</a>
                    </div>
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
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
