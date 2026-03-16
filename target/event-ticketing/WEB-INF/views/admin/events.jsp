<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Manage Events"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-events .card {
        border-radius: 18px;
    }

    .muted-note {
        margin: 0;
        color: #64748B;
    }

    .filter-shell {
        padding: 0.85rem;
        border: 1px solid #E2E8F0;
        border-radius: 14px;
        background: #FFFFFF;
    }

    .events-table th,
    .events-table td {
        white-space: nowrap;
    }

    .events-table td:first-child,
    .events-table th:first-child {
        white-space: normal;
        min-width: 220px;
    }

    .event-title {
        margin: 0;
        font-weight: 700;
        color: #2D3748;
    }

    .empty-state {
        text-align: center;
        color: #64748B;
        padding: 1rem;
    }

    .delete-modal .modal-body {
        color: #4A5568;
    }
</style>

<section class="admin-events dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Admin</h2>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/events">Events</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
                    <div>
                        <h1 class="section-title">Admin Events Management</h1>
                        <p class="muted-note">Showing <c:out value="${totalEvents}"/> events</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-soft">Back To Dashboard</a>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/admin/events" class="filter-shell mb-3">
                    <div class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label class="form-label" for="statusFilter">Filter By Status</label>
                            <select id="statusFilter" name="status" class="form-select">
                                <option value="" ${empty statusFilter ? 'selected' : ''}>All Statuses</option>
                                <option value="PENDING" ${statusFilter == 'PENDING' ? 'selected' : ''}>PENDING</option>
                                <option value="APPROVED" ${statusFilter == 'APPROVED' ? 'selected' : ''}>APPROVED</option>
                                <option value="CANCELLED" ${statusFilter == 'CANCELLED' ? 'selected' : ''}>CANCELLED</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <label class="form-label" for="tableSearch">Search By Title / Organizer</label>
                            <input id="tableSearch" type="text" class="form-control" placeholder="Type to filter visible rows...">
                        </div>
                        <div class="col-md-3 d-grid">
                            <button type="submit" class="btn-vivid">Apply Filter</button>
                        </div>
                    </div>
                </form>

                <div class="table-wrap table-responsive">
                    <table class="table align-middle events-table" id="adminEventsTable">
                        <thead>
                        <tr>
                            <th>Event Title</th>
                            <th>Organizer</th>
                            <th>Category</th>
                            <th>Date</th>
                            <th>Price</th>
                            <th>Tickets</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty events}">
                                <c:forEach items="${events}" var="event">
                                    <tr data-search="${fn:toLowerCase(event.title)} ${fn:toLowerCase(event.organizer.name)}">
                                        <td><p class="event-title"><c:out value="${event.title}"/></p></td>
                                        <td><c:out value="${event.organizer.name}"/></td>
                                        <td><span class="category-pill" data-category="${fn:escapeXml(event.category)}"><c:out value="${event.category}"/></span></td>
                                        <td><c:out value="${fn:replace(fn:substring(event.eventDate, 0, 16), 'T', ' ')}"/></td>
                                        <td><fmt:formatNumber value="${event.price}" type="currency"/></td>
                                        <td><strong><c:out value="${event.availableTickets}"/></strong> / <c:out value="${event.totalTickets}"/></td>
                                        <td>
                                            <span class="status-pill ${fn:toLowerCase(event.status.name())}"><c:out value="${event.status}"/></span>
                                        </td>
                                        <td>
                                            <div class="actions">
                                                <c:if test="${event.status.name() == 'PENDING'}">
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/approve-event">
                                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${event.id}">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="status" value="${statusFilter}">
                                                        <input type="hidden" name="page" value="${currentPage}">
                                                        <button class="btn-approve" type="submit">Approve</button>
                                                    </form>
                                                    <form method="post" action="${pageContext.request.contextPath}/admin/approve-event">
                                                        <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                        <input type="hidden" name="id" value="${event.id}">
                                                        <input type="hidden" name="action" value="reject">
                                                        <input type="hidden" name="status" value="${statusFilter}">
                                                        <input type="hidden" name="page" value="${currentPage}">
                                                        <button class="btn-reject" type="submit">Reject</button>
                                                    </form>
                                                </c:if>
                                                <button type="button"
                                                        class="btn-delete"
                                                        data-event-id="${event.id}"
                                                        data-event-title="${fn:escapeXml(event.title)}">Delete</button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="8" class="empty-state">No events found for the selected filter.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>

                <c:if test="${totalPages > 1}">
                    <nav class="mt-3" aria-label="Events pagination">
                        <ul class="pagination justify-content-center flex-wrap">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/events?page=${currentPage - 1}<c:if test='${not empty statusFilter}'>&status=${statusFilter}</c:if>">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="pageNumber">
                                <li class="page-item ${pageNumber == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/admin/events?page=${pageNumber}<c:if test='${not empty statusFilter}'>&status=${statusFilter}</c:if>"><c:out value="${pageNumber}"/></a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/admin/events?page=${currentPage + 1}<c:if test='${not empty statusFilter}'>&status=${statusFilter}</c:if>">Next</a>
                            </li>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>
</section>

<form id="deleteEventForm" method="post" action="${pageContext.request.contextPath}/admin/delete-event" class="d-none">
    <input type="hidden" name="csrfToken" value="${csrfToken}">
    <input type="hidden" name="id" id="deleteEventId">
    <input type="hidden" name="status" value="${statusFilter}">
    <input type="hidden" name="page" value="${currentPage}">
</form>

<div class="modal fade delete-modal" id="deleteEventModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Delete Event</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                Delete <strong id="deleteEventTitle"></strong>? This action cannot be undone.
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-cancel" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn-confirm-delete" id="confirmDeleteEventBtn">Delete</button>
            </div>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll(".category-pill[data-category]").forEach(function (badge) {
        const category = (badge.getAttribute("data-category") || "").toLowerCase();
        const palette = [
            ["#FFF1EA", "#FFD8C8", "#C2410C"],
            ["#E6FFFA", "#B8F0EA", "#0F766E"],
            ["#FFF7ED", "#FED7AA", "#9A3412"]
        ];
        let hash = 0;
        for (let i = 0; i < category.length; i += 1) {
            hash = category.charCodeAt(i) + ((hash << 5) - hash);
        }
        const c = palette[Math.abs(hash) % palette.length];
        badge.style.background = c[0];
        badge.style.borderColor = c[1];
        badge.style.color = c[2];
    });

    const searchInput = document.getElementById("tableSearch");
    const tableRows = Array.from(document.querySelectorAll("#adminEventsTable tbody tr[data-search]"));
    if (searchInput && tableRows.length) {
        searchInput.addEventListener("input", function () {
            const query = searchInput.value.trim().toLowerCase();
            tableRows.forEach(function (row) {
                const text = row.getAttribute("data-search") || "";
                row.style.display = (!query || text.indexOf(query) !== -1) ? "" : "none";
            });
        });
    }

    const deleteForm = document.getElementById("deleteEventForm");
    const deleteIdInput = document.getElementById("deleteEventId");
    const deleteTitle = document.getElementById("deleteEventTitle");
    const confirmDeleteBtn = document.getElementById("confirmDeleteEventBtn");
    const deleteModalEl = document.getElementById("deleteEventModal");
    const deleteModal = (deleteModalEl && window.bootstrap) ? new bootstrap.Modal(deleteModalEl) : null;

    document.querySelectorAll(".btn-delete[data-event-id]").forEach(function (button) {
        button.addEventListener("click", function () {
            if (!deleteModal || !deleteForm || !deleteIdInput || !deleteTitle) {
                return;
            }
            deleteIdInput.value = button.getAttribute("data-event-id");
            deleteTitle.textContent = button.getAttribute("data-event-title") || "this event";
            deleteModal.show();
        });
    });

    if (confirmDeleteBtn && deleteForm) {
        confirmDeleteBtn.addEventListener("click", function () {
            deleteForm.submit();
        });
    }
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
