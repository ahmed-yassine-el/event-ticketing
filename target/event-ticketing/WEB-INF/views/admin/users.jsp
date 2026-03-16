<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Manage Users"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-users .card {
        border-radius: 18px;
    }

    .users-table th,
    .users-table td {
        white-space: nowrap;
    }

    .users-table th:nth-child(2),
    .users-table td:nth-child(2),
    .users-table th:nth-child(3),
    .users-table td:nth-child(3) {
        white-space: normal;
        min-width: 180px;
    }

    .section-title {
        margin: 0 0 0.7rem;
        font-size: clamp(1.6rem, 3vw, 2.15rem);
    }
</style>

<section class="admin-users dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Admin</h2>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/events">Events</a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="card mb-4">
            <div class="card-body">
                <h1 class="section-title">Create User</h1>
                <form method="post" action="${pageContext.request.contextPath}/admin/users" class="row g-3">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <input type="hidden" name="action" value="create">
                    <div class="col-md-3"><input class="form-control" type="text" name="name" placeholder="Name" required></div>
                    <div class="col-md-3"><input class="form-control" type="email" name="email" placeholder="Email" required></div>
                    <div class="col-md-2"><input class="form-control" type="password" name="password" placeholder="Password" required></div>
                    <div class="col-md-2">
                        <select class="form-select" name="role" required>
                            <option value="PARTICIPANT">Participant</option>
                            <option value="ORGANIZER">Organizer</option>
                            <option value="ADMIN">Admin</option>
                        </select>
                    </div>
                    <div class="col-md-2 d-grid"><button class="btn-vivid" type="submit">Create</button></div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <h2 class="section-title">Users</h2>
                <div class="table-wrap table-responsive">
                    <table class="table table-hover align-middle users-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${users}" var="user">
                            <tr>
                                <td><c:out value="${user.id}"/></td>
                                <td><c:out value="${user.name}"/></td>
                                <td><c:out value="${user.email}"/></td>
                                <td><span class="role-pill"><c:out value="${user.role}"/></span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.active}"><span class="status-pill status-active">ACTIVE</span></c:when>
                                        <c:otherwise><span class="status-pill status-inactive">INACTIVE</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="actions">
                                        <button class="btn-soft" data-bs-toggle="modal" data-bs-target="#editUser${user.id}" type="button">Edit</button>
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users" class="d-inline">
                                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${user.id}">
                                            <button class="btn-danger-soft" type="submit">Delete</button>
                                        </form>
                                    </div>

                                    <div class="modal fade" id="editUser${user.id}" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog">
                                            <div class="modal-content">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/users">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Edit User #<c:out value="${user.id}"/></h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${user.id}">
                                                        <input type="hidden" name="action" value="update">
                                                        <div class="mb-2">
                                                            <label class="form-label">Name</label>
                                                            <input class="form-control" name="name" value="${fn:escapeXml(user.name)}" required>
                                                        </div>
                                                        <div class="mb-2">
                                                            <label class="form-label">Email</label>
                                                            <input class="form-control" type="email" name="email" value="${fn:escapeXml(user.email)}" required>
                                                        </div>
                                                        <div class="mb-2">
                                                            <label class="form-label">Role</label>
                                                            <select class="form-select" name="role" required>
                                                                <option value="PARTICIPANT" <c:if test="${user.role.name() == 'PARTICIPANT'}">selected</c:if>>PARTICIPANT</option>
                                                                <option value="ORGANIZER" <c:if test="${user.role.name() == 'ORGANIZER'}">selected</c:if>>ORGANIZER</option>
                                                                <option value="ADMIN" <c:if test="${user.role.name() == 'ADMIN'}">selected</c:if>>ADMIN</option>
                                                            </select>
                                                        </div>
                                                        <div class="mb-2">
                                                            <label class="form-label">Active</label>
                                                            <select class="form-select" name="active">
                                                                <option value="true" <c:if test="${user.active}">selected</c:if>>true</option>
                                                                <option value="false" <c:if test="${!user.active}">selected</c:if>>false</option>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Close</button>
                                                        <button type="submit" class="btn-modal-primary">Save</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
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
