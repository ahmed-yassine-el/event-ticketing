<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Home"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .home-page {
        display: grid;
        gap: 1.15rem;
    }

    .hero-shell {
        position: relative;
        overflow: hidden;
        padding: clamp(1.3rem, 4.5vw, 2.7rem);
    }

    .hero-shell::before,
    .hero-shell::after {
        content: "";
        position: absolute;
        border: 2px solid rgba(255, 107, 53, 0.2);
        transform: rotate(20deg);
    }

    .hero-shell::before {
        width: 170px;
        height: 170px;
        top: -80px;
        right: 2%;
    }

    .hero-shell::after {
        width: 130px;
        height: 130px;
        bottom: -60px;
        left: 4%;
    }

    .hero-kicker {
        margin: 0;
        text-transform: uppercase;
        font-size: 0.74rem;
        letter-spacing: 0.11em;
        color: #718096;
        font-weight: 700;
    }

    .hero-title {
        margin: 0.55rem 0;
        font-size: clamp(2rem, 4.8vw, 3.25rem);
        line-height: 1.05;
    }

    .hero-sub {
        margin: 0;
        max-width: 720px;
        color: #4A5568;
        font-size: 1rem;
    }

    .filter-shell {
        padding: 1rem;
    }

    .live-filter-shell {
        display: grid;
        gap: 0.45rem;
        padding: 1rem;
        border: 1px solid #E2E8F0;
        border-radius: 16px;
        background: #FFFFFF;
        box-shadow: var(--shadow-card);
    }

    .live-filter-shell label {
        margin: 0;
        font-size: 0.78rem;
        text-transform: uppercase;
        letter-spacing: 0.09em;
        color: #64748B;
        font-weight: 700;
    }

    .live-filter-shell input {
        border: 1px solid #D6DEE8;
        border-radius: 10px;
        min-height: 44px;
        padding: 0.6rem 0.8rem;
    }

    .live-filter-shell input:focus {
        outline: none;
        border-color: rgba(255, 107, 53, 0.7);
        box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.14);
    }

    .event-card {
        height: 100%;
        border-radius: 18px;
        overflow: hidden;
        border: 1px solid #E2E8F0;
    }

    .event-card .card-body {
        display: flex;
        flex-direction: column;
        gap: 0.55rem;
    }

    .event-title {
        margin: 0;
        font-size: 1.4rem;
        line-height: 1.14;
    }

    .meta-line {
        margin: 0;
        color: #4A5568;
        font-size: 0.92rem;
    }

    .event-price {
        display: inline-flex;
        align-items: center;
        width: fit-content;
        padding: 0.33rem 0.7rem;
        border-radius: 999px;
        background: #E6FFFA;
        color: #0F766E;
        border: 1px solid #99F6E4;
        font-size: 0.78rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.06em;
    }

    .sold-out-ribbon {
        position: absolute;
        top: 0.85rem;
        right: 0.85rem;
        background: #FFF1F2;
        color: #B91C1C;
        border: 1px solid #FECACA;
        border-radius: 999px;
        font-size: 0.72rem;
        font-weight: 700;
        padding: 0.24rem 0.6rem;
        z-index: 1;
    }

    .empty-shell {
        padding: 1.2rem;
        text-align: center;
        border-radius: 16px;
        border: 1px solid #E2E8F0;
        background: #FFFFFF;
        color: #64748B;
        box-shadow: var(--shadow-card);
    }

    #liveNoResults {
        display: none;
    }

    #liveNoResults.show {
        display: block;
    }
</style>

<section class="home-page" id="homePageRoot">
    <div class="hero-shell">
        <p class="hero-kicker">Luxury Magazine Ticketing</p>
        <h1 class="hero-title">Discover unforgettable events with editorial clarity</h1>
        <p class="hero-sub">Search by category, location, or date and reserve premium experiences in one elegant flow.</p>
    </div>

    <div class="filter-shell">
        <form method="get" action="${pageContext.request.contextPath}/home" class="row g-3 align-items-end">
            <div class="col-md-3">
                <label class="form-label" for="homeCategory">Category</label>
                <input type="text" id="homeCategory" name="category" class="form-control filter-field" placeholder="Category" value="${fn:escapeXml(param.category)}">
            </div>
            <div class="col-md-3">
                <label class="form-label" for="homeLocation">Location</label>
                <input type="text" id="homeLocation" name="location" class="form-control filter-field" placeholder="Location" value="${fn:escapeXml(param.location)}">
            </div>
            <div class="col-md-3">
                <label class="form-label" for="homeDate">Date</label>
                <input type="date" id="homeDate" name="date" class="form-control filter-field" value="${fn:escapeXml(param.date)}">
            </div>
            <div class="col-md-3 d-grid">
                <button type="submit" class="btn btn-vivid">Search Events</button>
            </div>
        </form>
    </div>

    <div class="live-filter-shell">
        <label for="liveEventFilter">Live Filter</label>
        <input type="text" id="liveEventFilter" placeholder="Type event, category, or location">
    </div>

    <div class="row g-4" id="homeEventsGrid">
        <c:choose>
            <c:when test="${not empty events}">
                <c:forEach items="${events}" var="event">
                    <div class="col-md-6 col-lg-4" data-event-item>
                        <div class="card event-card" data-event-card data-search="${fn:toLowerCase(event.title)} ${fn:toLowerCase(event.category)} ${fn:toLowerCase(event.location)}">
                            <c:if test="${event.availableTickets == 0}">
                                <span class="sold-out-ribbon">Sold Out</span>
                            </c:if>
                            <div class="card-body">
                                <span class="category-badge" data-category="${fn:escapeXml(event.category)}"><c:out value="${event.category}"/></span>
                                <h2 class="event-title"><c:out value="${event.title}"/></h2>
                                <p class="meta-line"><strong>Location:</strong> <c:out value="${event.location}"/></p>
                                <p class="meta-line"><strong>Date:</strong> <c:out value="${event.eventDate}"/></p>
                                <span class="event-price"><fmt:formatNumber value="${event.price}" type="currency"/></span>
                                <span class="ticket-pill">Available: <c:out value="${event.availableTickets}"/></span>
                                <a href="${pageContext.request.contextPath}/event?id=${event.id}" class="btn-outline-vivid mt-1">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="empty-shell">
                        <p>No events found for your filters.</p>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div id="liveNoResults" class="empty-shell">
        <p>No event matches your live search.</p>
    </div>
</section>

<script>
    (function () {
        const badges = document.querySelectorAll(".category-badge[data-category]");
        const palette = [
            ["#FFF1EA", "#FFD8C8", "#C2410C"],
            ["#E6FFFA", "#B8F0EA", "#0F766E"],
            ["#FFF7ED", "#FED7AA", "#9A3412"]
        ];
        badges.forEach(function (badge) {
            const category = (badge.getAttribute("data-category") || "").toLowerCase();
            let hash = 0;
            for (let i = 0; i < category.length; i += 1) {
                hash = category.charCodeAt(i) + ((hash << 5) - hash);
            }
            const c = palette[Math.abs(hash) % palette.length];
            badge.style.background = c[0];
            badge.style.borderColor = c[1];
            badge.style.color = c[2];
        });

        const liveFilter = document.getElementById("liveEventFilter");
        const eventItems = Array.from(document.querySelectorAll("[data-event-item]"));
        const noResults = document.getElementById("liveNoResults");

        if (liveFilter && eventItems.length) {
            liveFilter.addEventListener("input", function () {
                const query = liveFilter.value.trim().toLowerCase();
                let visible = 0;
                eventItems.forEach(function (item) {
                    const card = item.querySelector("[data-event-card]");
                    if (!card) {
                        return;
                    }
                    const text = (card.getAttribute("data-search") || "").toLowerCase();
                    const show = !query || text.indexOf(query) !== -1;
                    item.style.display = show ? "" : "none";
                    if (show) {
                        visible += 1;
                    }
                });
                if (noResults) {
                    noResults.classList.toggle("show", visible === 0);
                }
            });
        }
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
