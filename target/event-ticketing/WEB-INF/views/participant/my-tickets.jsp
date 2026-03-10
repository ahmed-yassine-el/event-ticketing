<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="My Tickets"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .my-tickets-page {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .my-tickets-page .tickets-shell {
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 28px 46px rgba(5, 6, 16, 0.4);
        padding: 1.1rem;
    }

    .my-tickets-page .tickets-title {
        margin: 0 0 1rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.6rem, 3.8vw, 2.2rem);
        line-height: 1.08;
        background: linear-gradient(115deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .my-tickets-page .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        background: rgba(6, 8, 22, 0.62);
        overflow: hidden;
    }

    .my-tickets-page .ticket-table {
        margin: 0;
        color: #EDF0FF;
        --bs-table-bg: transparent;
        --bs-table-color: #EDF0FF;
        --bs-table-striped-bg: rgba(255, 255, 255, 0.04);
        --bs-table-striped-color: #EDF0FF;
    }

    .my-tickets-page .ticket-table thead th {
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        font-size: 0.75rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: rgba(215, 220, 247, 0.78);
        background: rgba(255, 255, 255, 0.04);
        white-space: nowrap;
    }

    .my-tickets-page .ticket-table td,
    .my-tickets-page .ticket-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.85rem 0.75rem;
        vertical-align: middle;
    }

    .my-tickets-page .event-name {
        font-weight: 700;
        color: #FAFAFF;
    }

    .my-tickets-page .status-pill {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.22);
        padding: 0.25rem 0.66rem;
        font-size: 0.72rem;
        letter-spacing: 0.04em;
        font-weight: 700;
    }

    .my-tickets-page .status-active {
        background: rgba(34, 197, 94, 0.22);
        border-color: rgba(34, 197, 94, 0.55);
        color: #D3FFE1;
    }

    .my-tickets-page .status-cancelled {
        background: rgba(239, 68, 68, 0.2);
        border-color: rgba(248, 113, 113, 0.6);
        color: #FFDADF;
    }

    .my-tickets-page .status-transferred {
        background: rgba(245, 158, 11, 0.22);
        border-color: rgba(251, 191, 36, 0.62);
        color: #FFF0C8;
    }

    .my-tickets-page .btn-row {
        display: flex;
        flex-wrap: wrap;
        gap: 0.45rem;
    }

    .my-tickets-page .btn-pill {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 0.8rem;
        border: 1px solid transparent;
        font-size: 0.8rem;
        font-weight: 600;
        min-height: 34px;
        padding: 0.35rem 0.68rem;
        text-decoration: none;
        background: transparent;
        transition: transform 0.22s ease, box-shadow 0.22s ease, background-color 0.22s ease;
    }

    .my-tickets-page .btn-pill:hover {
        transform: translateY(-1px);
    }

    .my-tickets-page .btn-qr {
        border-color: rgba(255, 255, 255, 0.3);
        color: #F2F3FF;
        background: rgba(255, 255, 255, 0.08);
    }

    .my-tickets-page .btn-qr:hover {
        color: #FFFFFF;
        background: rgba(255, 255, 255, 0.16);
    }

    .my-tickets-page .btn-show-qr {
        border-color: rgba(124, 58, 237, 0.68);
        color: #EEE2FF;
        background: rgba(124, 58, 237, 0.2);
    }

    .my-tickets-page .btn-show-qr:hover {
        background: rgba(124, 58, 237, 0.34);
    }

    .my-tickets-page .btn-cancel {
        border-color: rgba(248, 113, 113, 0.66);
        color: #FFE1E5;
        background: rgba(239, 68, 68, 0.17);
    }

    .my-tickets-page .btn-cancel:hover {
        background: rgba(239, 68, 68, 0.27);
    }

    .my-tickets-page .btn-transfer {
        border-color: rgba(124, 58, 237, 0.66);
        color: #EFDFFF;
        background: rgba(124, 58, 237, 0.2);
    }

    .my-tickets-page .btn-transfer:hover {
        background: rgba(124, 58, 237, 0.32);
    }

    .my-tickets-page .muted-text {
        color: rgba(186, 191, 228, 0.74);
        font-size: 0.84rem;
    }

    .my-tickets-page .qr-reveal {
        margin-top: 0.65rem;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        background: rgba(8, 10, 24, 0.6);
        max-height: 0;
        overflow: hidden;
        opacity: 0;
        transform: translateY(12px);
        transition: max-height 0.35s ease, opacity 0.35s ease, transform 0.35s ease, padding 0.35s ease;
        padding: 0 0.75rem;
    }

    .my-tickets-page .qr-reveal.show {
        max-height: 260px;
        opacity: 1;
        transform: translateY(0);
        padding: 0.7rem 0.75rem;
    }

    .my-tickets-page .qr-image-wrap {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .my-tickets-page .qr-image {
        width: 170px;
        max-width: 100%;
        border-radius: 0.9rem;
        border: 1px solid rgba(255, 255, 255, 0.22);
        box-shadow: 0 18px 32px rgba(10, 12, 30, 0.4);
        transform: scale(0.88);
        opacity: 0;
        transition: transform 0.35s ease, opacity 0.35s ease;
    }

    .my-tickets-page .qr-reveal.show .qr-image {
        transform: scale(1);
        opacity: 1;
    }

    .my-tickets-page .modal-content {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(22, 24, 46, 0.96), rgba(12, 13, 25, 0.96));
        color: #EAEAFB;
        backdrop-filter: blur(20px);
    }

    .my-tickets-page .modal-header,
    .my-tickets-page .modal-footer {
        border-color: rgba(255, 255, 255, 0.11);
    }

    .my-tickets-page .modal-title {
        font-family: "Syne", sans-serif;
        font-size: 1.16rem;
    }

    .my-tickets-page .btn-close {
        filter: invert(1);
        opacity: 0.82;
    }

    .my-tickets-page .form-label {
        font-size: 0.76rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(215, 220, 246, 0.78);
    }

    .my-tickets-page .form-control {
        border-radius: 0.85rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: rgba(8, 10, 24, 0.68);
        color: #F4F5FF;
        min-height: 44px;
    }

    .my-tickets-page .form-control:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 0.18rem rgba(124, 58, 237, 0.26);
        background: rgba(10, 13, 30, 0.88);
        color: #FFFFFF;
    }

    .my-tickets-page .btn-modal-secondary,
    .my-tickets-page .btn-modal-primary {
        border: 0;
        border-radius: 0.8rem;
        min-height: 40px;
        font-weight: 700;
        padding: 0.45rem 0.9rem;
    }

    .my-tickets-page .btn-modal-secondary {
        color: #E5E8FF;
        background: rgba(255, 255, 255, 0.13);
        border: 1px solid rgba(255, 255, 255, 0.24);
    }

    .my-tickets-page .btn-modal-primary {
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 14px 26px rgba(124, 58, 237, 0.3);
    }

    @media (max-width: 991.98px) {
        .my-tickets-page .table-wrap {
            overflow-x: auto;
        }

        .my-tickets-page .ticket-table {
            min-width: 980px;
        }
    }

    @media (max-width: 767.98px) {
        .my-tickets-page .tickets-shell {
            padding: 0.85rem;
            border-radius: 1rem;
        }

        .my-tickets-page .tickets-title {
            margin-bottom: 0.8rem;
        }
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
                                <c:otherwise><span class="status-pill status-transferred">TRANSFERRED</span></c:otherwise>
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
