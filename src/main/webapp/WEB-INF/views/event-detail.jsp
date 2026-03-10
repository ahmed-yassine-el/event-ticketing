<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Event Details"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    body.app-shell {
        overflow-x: hidden;
    }

    .event-detail-page {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
    }

    .event-detail-page .detail-shell {
        width: 100%;
        position: relative;
        border-radius: 1.3rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.13), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 28px 46px rgba(5, 6, 17, 0.42);
        padding: clamp(1.15rem, 2.4vw, 2rem);
        overflow: hidden;
    }

    .event-detail-page .row {
        margin-left: 0;
        margin-right: 0;
    }

    .event-detail-page .detail-shell::before,
    .event-detail-page .detail-shell::after {
        content: "";
        position: absolute;
        border-radius: 999px;
        opacity: 0.7;
        filter: blur(4px);
        pointer-events: none;
        animation: detailFloat 16s ease-in-out infinite;
    }

    .event-detail-page .detail-shell::before {
        width: 220px;
        height: 220px;
        right: -80px;
        top: -80px;
        background: radial-gradient(circle, rgba(124, 58, 237, 0.9), rgba(124, 58, 237, 0));
    }

    .event-detail-page .detail-shell::after {
        width: 180px;
        height: 180px;
        left: -70px;
        bottom: -70px;
        background: radial-gradient(circle, rgba(236, 72, 153, 0.86), rgba(236, 72, 153, 0));
        animation-delay: -5s;
    }

    .event-detail-page .detail-title {
        margin: 0 0 0.68rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.7rem, 3.8vw, 2.65rem);
        line-height: 1.05;
        background: linear-gradient(115deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .event-detail-page .category-badge {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(100deg, rgba(124, 58, 237, 0.46), rgba(37, 99, 235, 0.4), rgba(236, 72, 153, 0.42));
        color: #FFFFFF;
        font-size: 0.72rem;
        letter-spacing: 0.05em;
        text-transform: uppercase;
        padding: 0.28rem 0.7rem;
        margin-bottom: 0.7rem;
        max-width: max-content;
    }

    .event-detail-page .desc-line,
    .event-detail-page .meta-line {
        position: relative;
        z-index: 1;
        margin-bottom: 0.6rem;
        color: rgba(228, 231, 252, 0.84);
    }

    .event-detail-page .desc-line strong,
    .event-detail-page .meta-line strong {
        color: rgba(246, 247, 255, 0.96);
    }

    .event-detail-page .ticket-pill {
        display: inline-flex;
        align-items: center;
        margin: 0.4rem 0 1.2rem;
        border-radius: 999px;
        border: 1px solid rgba(255, 255, 255, 0.22);
        padding: 0.36rem 0.88rem;
        background: linear-gradient(100deg, rgba(124, 58, 237, 0.38), rgba(37, 99, 235, 0.34), rgba(236, 72, 153, 0.4));
        color: #F6F8FF;
        font-size: 0.86rem;
    }

    .event-detail-page .buy-shell {
        position: relative;
        z-index: 1;
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        padding: 0.95rem;
        background: rgba(6, 8, 23, 0.56);
    }

    .event-detail-page .form-select,
    .event-detail-page .form-control {
        border-radius: 0.88rem;
        border: 1px solid rgba(255, 255, 255, 0.22);
        min-height: 46px;
        background: rgba(8, 10, 24, 0.72);
        color: #F4F5FF;
    }

    .event-detail-page .form-select:focus,
    .event-detail-page .form-control:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 0.18rem rgba(124, 58, 237, 0.26);
        background: rgba(10, 13, 30, 0.9);
        color: #FFFFFF;
    }

    .event-detail-page .form-select option {
        color: #F4F5FF;
        background: #111324;
    }

    .event-detail-page .btn-vivid,
    .event-detail-page .btn-soft,
    .event-detail-page .float-buy-btn {
        border: 0;
        border-radius: 0.88rem;
        min-height: 46px;
        font-weight: 700;
        letter-spacing: 0.01em;
        transition: transform 0.24s ease, box-shadow 0.24s ease;
    }

    .event-detail-page .btn-vivid,
    .event-detail-page .float-buy-btn {
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 18px 32px rgba(124, 58, 237, 0.3);
    }

    .event-detail-page .btn-vivid:hover,
    .event-detail-page .float-buy-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 24px 36px rgba(236, 72, 153, 0.34);
    }

    .event-detail-page .btn-soft {
        color: #F9EEFF;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 0.62rem 1rem;
        background: rgba(236, 72, 153, 0.16);
        border: 1px solid rgba(236, 72, 153, 0.7);
    }

    .event-detail-page .btn-soft:hover {
        color: #FFFFFF;
        background: rgba(124, 58, 237, 0.3);
        border-color: rgba(124, 58, 237, 0.9);
        transform: translateY(-1px);
    }

    .event-detail-page .float-buy-btn {
        position: fixed;
        right: 1rem;
        bottom: 4.25rem;
        z-index: 1120;
        min-height: 44px;
        padding: 0.5rem 0.92rem;
        opacity: 0;
        visibility: hidden;
        transform: translateY(14px);
    }

    .event-detail-page .float-buy-btn.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    @keyframes detailFloat {
        0%, 100% { transform: translateY(0) scale(1); }
        50% { transform: translateY(-14px) scale(1.07); }
    }

    @media (max-width: 767.98px) {
        .event-detail-page .float-buy-btn {
            right: 0.75rem;
            bottom: 4rem;
        }
    }
</style>

<section class="event-detail-page">
    <div class="row justify-content-center">
        <div class="col-lg-9">
            <div class="detail-shell">
                <span class="category-badge"><c:out value="${event.category}"/></span>
                <h1 class="detail-title"><c:out value="${event.title}"/></h1>
                <p class="desc-line"><strong>Description:</strong> <c:out value="${event.description}"/></p>
                <p class="meta-line"><strong>Location:</strong> <c:out value="${event.location}"/></p>
                <p class="meta-line"><strong>Date:</strong> <c:out value="${event.eventDate}"/></p>
                <p class="meta-line"><strong>Price:</strong> <fmt:formatNumber value="${event.price}" type="currency"/></p>
                <span class="ticket-pill">Available: <c:out value="${event.availableTickets}"/></span>

                <c:if test="${not empty sessionScope.loggedUser and sessionScope.loggedUser.role.name() == 'PARTICIPANT'}">
                    <div class="buy-shell">
                        <form method="post" id="buyTicketForm" action="${pageContext.request.contextPath}/buy-ticket" class="row g-3 align-items-end">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="eventId" value="${event.id}">
                            <div class="col-md-7 col-lg-5">
                                <label class="form-label" for="paymentMethod" style="font-size:0.78rem;text-transform:uppercase;letter-spacing:.08em;color:rgba(214,219,246,.75);">Payment Method</label>
                                <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                    <option value="CARD">Card</option>
                                    <option value="WALLET">Wallet</option>
                                    <option value="BANK_TRANSFER">Bank Transfer</option>
                                </select>
                            </div>
                            <div class="col-md-5 col-lg-4 d-grid">
                                <button type="submit" class="btn btn-vivid">Buy Ticket</button>
                            </div>
                        </form>
                    </div>
                </c:if>

                <c:if test="${empty sessionScope.loggedUser}">
                    <a href="${pageContext.request.contextPath}/login" class="btn-soft">Login to Purchase</a>
                </c:if>
            </div>
        </div>
    </div>

    <c:if test="${not empty sessionScope.loggedUser and sessionScope.loggedUser.role.name() == 'PARTICIPANT'}">
        <button type="button" id="floatBuyBtn" class="float-buy-btn">Buy Ticket</button>
    </c:if>
</section>

<script>
    (function () {
        const form = document.getElementById("buyTicketForm");
        const floatBtn = document.getElementById("floatBuyBtn");
        if (!form || !floatBtn) {
            return;
        }

        function updateFloatButton() {
            const y = window.pageYOffset || document.documentElement.scrollTop || 0;
            floatBtn.classList.toggle("show", y > 240);
        }

        floatBtn.addEventListener("click", function () {
            form.requestSubmit();
        });

        updateFloatButton();
        window.addEventListener("scroll", updateFloatButton, { passive: true });
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
