<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Manage Users"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-users {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .admin-users .glass-card {
        border-radius: 1.2rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 26px 44px rgba(7, 8, 20, 0.4);
    }

    .admin-users .glass-card .card-body {
        padding: 1.05rem;
    }

    .admin-users .section-title {
        margin: 0 0 0.9rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.3rem, 3vw, 1.8rem);
        line-height: 1.1;
        color: #F7F8FF;
    }

    .admin-users .form-control,
    .admin-users .form-select {
        border-radius: 0.85rem;
        border: 1px solid rgba(255, 255, 255, 0.22);
        background: rgba(8, 10, 24, 0.68);
        color: #F4F5FF;
        min-height: 42px;
    }

    .admin-users .form-control:focus,
    .admin-users .form-select:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 0.18rem rgba(124, 58, 237, 0.25);
        background: rgba(10, 13, 30, 0.9);
        color: #FFFFFF;
    }

    .admin-users .form-label {
        font-size: 0.76rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(215, 220, 248, 0.78);
    }

    .admin-users .btn-vivid,
    .admin-users .btn-soft,
    .admin-users .btn-danger-soft {
        border: 0;
        border-radius: 0.8rem;
        min-height: 34px;
        padding: 0.38rem 0.72rem;
        font-size: 0.79rem;
        font-weight: 700;
        transition: transform 0.2s ease, background-color 0.2s ease;
    }

    .admin-users .btn-vivid {
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 14px 26px rgba(124, 58, 237, 0.3);
    }

    .admin-users .btn-vivid:hover {
        transform: translateY(-1px);
    }

    .admin-users .btn-soft {
        color: #EFE4FF;
        background: rgba(124, 58, 237, 0.24);
        border: 1px solid rgba(124, 58, 237, 0.66);
    }

    .admin-users .btn-soft:hover {
        color: #FFFFFF;
        background: rgba(124, 58, 237, 0.34);
        transform: translateY(-1px);
    }

    .admin-users .btn-danger-soft {
        color: #FFE2E8;
        background: rgba(239, 68, 68, 0.24);
        border: 1px solid rgba(248, 113, 113, 0.66);
    }

    .admin-users .btn-danger-soft:hover {
        color: #FFFFFF;
        background: rgba(239, 68, 68, 0.34);
        transform: translateY(-1px);
    }

    .admin-users .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        overflow: hidden;
        background: rgba(8, 10, 24, 0.58);
    }

    .admin-users .users-table {
        margin: 0;
        --bs-table-bg: transparent;
        --bs-table-hover-bg: rgba(255, 255, 255, 0.04);
        --bs-table-hover-color: #EFF2FF;
        color: #EFF2FF;
    }

    .admin-users .users-table thead th {
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        color: rgba(215, 220, 248, 0.78);
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        white-space: nowrap;
    }

    .admin-users .users-table td,
    .admin-users .users-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.78rem 0.68rem;
        vertical-align: middle;
    }

    .admin-users .role-pill,
    .admin-users .status-pill {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.24rem 0.6rem;
        font-size: 0.71rem;
        font-weight: 700;
        letter-spacing: 0.04em;
    }

    .admin-users .role-pill {
        background: rgba(124, 58, 237, 0.25);
        border-color: rgba(124, 58, 237, 0.65);
        color: #F0E6FF;
    }

    .admin-users .status-active {
        background: rgba(34, 197, 94, 0.22);
        border-color: rgba(34, 197, 94, 0.58);
        color: #D7FFE4;
    }

    .admin-users .status-inactive {
        background: rgba(239, 68, 68, 0.22);
        border-color: rgba(248, 113, 113, 0.62);
        color: #FFDDE4;
    }

    .admin-users .actions {
        display: flex;
        gap: 0.45rem;
        flex-wrap: wrap;
    }

    .admin-users .modal-content {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(22, 24, 46, 0.96), rgba(11, 12, 24, 0.96));
        color: #EFF2FF;
        backdrop-filter: blur(20px);
    }

    .admin-users .modal-header,
    .admin-users .modal-footer {
        border-color: rgba(255, 255, 255, 0.11);
    }

    .admin-users .modal-title {
        font-family: "Syne", sans-serif;
        font-size: 1.12rem;
    }

    .admin-users .btn-close {
        filter: invert(1);
        opacity: 0.82;
    }

    .admin-users .btn-modal-secondary,
    .admin-users .btn-modal-primary {
        border: 0;
        border-radius: 0.78rem;
        min-height: 38px;
        font-weight: 700;
        padding: 0.42rem 0.82rem;
    }

    .admin-users .btn-modal-secondary {
        color: #E5E8FF;
        background: rgba(255, 255, 255, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.22);
    }

    .admin-users .btn-modal-primary {
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 12px 24px rgba(124, 58, 237, 0.3);
    }

    @media (max-width: 991.98px) {
        .admin-users .table-wrap {
            overflow-x: auto;
        }

        .admin-users .users-table {
            min-width: 980px;
        }
    }
</style>

<section class="admin-users">
    <div class="glass-card card mb-4">
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

    <div class="glass-card card">
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
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
