<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="My Tickets"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .my-tickets-page {
        display: grid;
        gap: 1rem;
    }

    .tickets-shell {
        padding: clamp(1rem, 2.7vw, 1.4rem);
    }

    .tickets-title {
        margin: 0 0 0.75rem;
        font-size: clamp(1.8rem, 3.2vw, 2.35rem);
    }

    .event-name {
        font-weight: 700;
        color: #2D3748;
    }

    .qr-reveal {
        display: none;
        margin-top: 0.55rem;
    }

    .qr-reveal.show {
        display: block;
    }

    .qr-image-wrap {
        border-radius: 12px;
        border: 1px solid #E2E8F0;
        background: #FFFFFF;
        padding: 0.55rem;
        width: fit-content;
    }

    .qr-image {
        width: 112px;
        height: 112px;
        object-fit: contain;
        display: block;
    }

    .muted-text {
        color: #64748B;
        font-size: 0.85rem;
    }

    .modal-body .form-control {
        min-height: 42px;
    }
</style>

<section class="my-tickets-page">
    <div class="tickets-shell">
        <h1 class="tickets-title">My Tickets</h1>
        <div class="table-wrap table-responsive">
            <table class="table table-striped align-middle ticket-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Event</th>
                    <th>Purchase Date</th>
                    <th>Status</th>
                    <th>QR</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${tickets}" var="ticket">
                    <tr>
                        <td><c:out value="${ticket.id}"/></td>
                        <td><span class="event-name"><c:out value="${ticket.event.title}"/></span></td>
                        <td><c:out value="${ticket.purchaseDate}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${ticket.status.name() == 'ACTIVE'}"><span class="status-pill status-active">ACTIVE</span></c:when>
                                <c:when test="${ticket.status.name() == 'CANCELLED'}"><span class="status-pill status-cancelled">CANCELLED</span></c:when>
                                <c:otherwise><span class="status-pill" style="background:#E0F2FE;color:#075985;">TRANSFERRED</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${not empty ticket.qrCode}">
                                <div class="btn-row">
                                    <a class="btn-pill btn-qr" download="ticket-${ticket.id}.png" href="data:image/png;base64,${ticket.qrCode}">Download QR</a>
                                    <button type="button" class="btn-pill btn-show-qr" data-qr-toggle="qrReveal${ticket.id}">Reveal QR</button>
                                </div>
                                <div id="qrReveal${ticket.id}" class="qr-reveal">
                                    <div class="qr-image-wrap">
                                        <img class="qr-image" src="data:image/png;base64,${ticket.qrCode}" alt="Ticket QR code">
                                    </div>
                                </div>
                            </c:if>
                            <c:if test="${empty ticket.qrCode}">
                                <span class="muted-text">Not generated</span>
                            </c:if>
                        </td>
                        <td>
                            <div class="btn-row">
                                <form method="post" action="${pageContext.request.contextPath}/cancel-ticket">
                                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                                    <input type="hidden" name="ticketId" value="${ticket.id}">
                                    <button class="btn-pill btn-cancel" type="submit">Cancel</button>
                                </form>
                                <button class="btn-pill btn-transfer" data-bs-toggle="modal" data-bs-target="#transferModal${ticket.id}" type="button">Transfer</button>
                            </div>

                            <div class="modal fade" id="transferModal${ticket.id}" tabindex="-1" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <h5 class="modal-title">Transfer Ticket #<c:out value="${ticket.id}"/></h5>
                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                        </div>
                                        <form method="post" action="${pageContext.request.contextPath}/transfer-ticket">
                                            <div class="modal-body">
                                                <input type="hidden" name="csrfToken" value="${csrfToken}">
                                                <input type="hidden" name="ticketId" value="${ticket.id}">
                                                <label class="form-label" for="newParticipantEmail${ticket.id}">Recipient Email</label>
                                                <input type="email" class="form-control" id="newParticipantEmail${ticket.id}" name="newParticipantEmail" required>
                                            </div>
                                            <div class="modal-footer">
                                                <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Close</button>
                                                <button type="submit" class="btn-modal-primary">Transfer</button>
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
</section>

<script>
    (function () {
        document.querySelectorAll("[data-qr-toggle]").forEach(function (btn) {
            btn.addEventListener("click", function () {
                const id = btn.getAttribute("data-qr-toggle");
                const panel = document.getElementById(id);
                if (!panel) {
                    return;
                }
                const isOpen = panel.classList.contains("show");
                panel.classList.toggle("show", !isOpen);
                btn.textContent = isOpen ? "Reveal QR" : "Hide QR";
            });
        });
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
