<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Event Details"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .event-detail-page {
        display: grid;
        gap: 1rem;
    }

    .detail-shell {
        padding: clamp(1.1rem, 3vw, 1.8rem);
        position: relative;
        overflow: hidden;
    }

    .detail-shell::after {
        content: "";
        position: absolute;
        width: 170px;
        height: 170px;
        border: 2px solid rgba(255, 107, 53, 0.18);
        transform: rotate(22deg);
        right: -70px;
        top: -82px;
        pointer-events: none;
    }

    .detail-title {
        margin: 0.55rem 0 0.75rem;
        font-size: clamp(1.8rem, 4vw, 2.8rem);
        line-height: 1.08;
    }

    .desc-line,
    .meta-line {
        margin: 0 0 0.6rem;
        color: #4A5568;
    }

    .buy-shell {
        margin-top: 1rem;
        padding-top: 1rem;
        border-top: 1px solid #E2E8F0;
    }

    .btn-soft {
        margin-top: 1rem;
    }

    .location-shell {
        padding: 1rem;
        border: 1px solid #E2E8F0;
        border-radius: 18px;
        background: #FFFFFF;
        box-shadow: var(--shadow-card);
    }

    .location-title {
        margin: 0 0 0.7rem;
        font-size: 1.45rem;
    }

    .float-buy-btn {
        position: fixed;
        right: 16px;
        bottom: 72px;
        border: 0;
        border-radius: 999px;
        padding: 0.7rem 1.15rem;
        font-weight: 700;
        background: #FF6B35;
        color: #FFFFFF;
        box-shadow: 0 14px 28px rgba(255, 107, 53, 0.32);
        opacity: 0;
        transform: translateY(10px);
        pointer-events: none;
        transition: 0.2s ease;
        z-index: 998;
    }

    .float-buy-btn.show {
        opacity: 1;
        transform: translateY(0);
        pointer-events: auto;
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
                <fmt:parseDate value="${fn:substring(event.eventDate, 0, 16)}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedEventDate"/>
                <p class="meta-line"><strong>Date:</strong> <fmt:formatDate value="${parsedEventDate}" pattern="MMMM dd, yyyy - HH:mm"/></p>
                <p class="meta-line"><strong>Price:</strong> <fmt:formatNumber value="${event.price}" type="currency"/></p>
                <span class="ticket-pill">Available: <c:out value="${event.availableTickets}"/></span>
                <p class="meta-line mt-2"><strong>Lat:</strong> <c:out value="${event.latitude}"/> - <strong>Lng:</strong> <c:out value="${event.longitude}"/></p>

                <c:if test="${not empty sessionScope.loggedUser and sessionScope.loggedUser.role.name() == 'PARTICIPANT'}">
                    <div class="buy-shell">
                        <form method="post" id="buyTicketForm" action="${pageContext.request.contextPath}/buy-ticket" class="row g-3 align-items-end">
                            <input type="hidden" name="csrfToken" value="${csrfToken}">
                            <input type="hidden" name="eventId" value="${event.id}">
                            <div class="col-md-7 col-lg-5">
                                <label class="form-label" for="paymentMethod">Payment Method</label>
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

    <c:if test="${event.latitude != null && event.longitude != null}">
        <div class="row justify-content-center mt-3">
            <div class="col-lg-9">
                <div class="location-shell">
                    <h2 class="location-title">Event Location</h2>
                    <div id="map" style="height:350px;width:100%; border-radius:16px;z-index:1;"></div>
                    <script>
                    document.addEventListener('DOMContentLoaded', function() {
                      var lat = ${event.latitude};
                      var lng = ${event.longitude};
                      var map = L.map('map').setView([lat, lng], 13);
                      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '&copy; OpenStreetMap contributors'
                      }).addTo(map);
                      L.marker([lat, lng]).addTo(map);
                    });
                    </script>
                </div>
            </div>
        </div>
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
