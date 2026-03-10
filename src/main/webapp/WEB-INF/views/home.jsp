<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Home"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    body.app-shell {
        overflow-x: hidden;
    }

    .home-page {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
        color: #ECECFA;
        position: relative;
        isolation: isolate;
        width: 100%;
        max-width: 1200px;
        margin: 0 auto;
    }

    .home-page .particle-canvas {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 100%;
        z-index: 0;
        pointer-events: none;
        opacity: 0.55;
    }

    .home-page .content-layer {
        position: relative;
        z-index: 1;
    }

    .home-page .hero-shell,
    .home-page .filter-shell,
    .home-page .event-card,
    .home-page .empty-shell {
        width: 100%;
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 24px 45px rgba(5, 6, 16, 0.38);
    }

    .home-page .row {
        margin-left: 0;
        margin-right: 0;
    }

    .home-page .hero-shell {
        position: relative;
        overflow: hidden;
        padding: clamp(1.3rem, 2vw, 2.1rem);
        margin-bottom: 1.1rem;
    }

    .home-page .hero-shell::before,
    .home-page .hero-shell::after {
        content: "";
        position: absolute;
        border-radius: 999px;
        filter: blur(4px);
        opacity: 0.7;
        pointer-events: none;
        animation: homeFloat 16s ease-in-out infinite;
    }

    .home-page .hero-shell::before {
        width: 220px;
        height: 220px;
        left: -70px;
        top: -70px;
        background: radial-gradient(circle, rgba(124, 58, 237, 0.9), rgba(124, 58, 237, 0));
    }

    .home-page .hero-shell::after {
        width: 200px;
        height: 200px;
        right: -55px;
        bottom: -70px;
        background: radial-gradient(circle, rgba(236, 72, 153, 0.85), rgba(236, 72, 153, 0));
        animation-delay: -6s;
    }

    .home-page .hero-kicker {
        margin: 0 0 0.45rem;
        font-size: 0.76rem;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: rgba(218, 223, 249, 0.72);
    }

    .home-page .hero-title {
        margin: 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.85rem, 4.2vw, 3.1rem);
        line-height: 1.06;
        background: linear-gradient(110deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .home-page .hero-sub {
        margin: 0.72rem 0 0;
        max-width: 700px;
        color: rgba(231, 234, 253, 0.84);
    }

    .home-page .filter-shell {
        padding: 1rem;
        margin-bottom: 1.15rem;
    }

    .home-page .filter-shell .form-label {
        font-size: 0.77rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(214, 219, 246, 0.7);
        margin-bottom: 0.34rem;
    }

    .home-page .filter-field.form-control {
        border-radius: 0.9rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: rgba(8, 10, 24, 0.64);
        color: #F4F5FF;
        min-height: 46px;
        padding: 0.6rem 0.8rem;
    }

    .home-page .filter-field.form-control::placeholder {
        color: rgba(189, 194, 228, 0.58);
    }

    .home-page .filter-field.form-control:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 0.18rem rgba(124, 58, 237, 0.27);
        background: rgba(8, 11, 26, 0.82);
        color: #FFFFFF;
    }

    .home-page .btn-vivid {
        border: 0;
        border-radius: 0.9rem;
        min-height: 46px;
        font-weight: 700;
        letter-spacing: 0.01em;
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 18px 30px rgba(124, 58, 237, 0.28);
        transition: transform 0.24s ease, box-shadow 0.24s ease;
    }

    .home-page .btn-vivid:hover {
        transform: translateY(-2px);
        box-shadow: 0 22px 34px rgba(236, 72, 153, 0.33);
    }

    .home-page .live-filter-shell {
        margin-bottom: 1.1rem;
        display: flex;
        align-items: center;
        gap: 0.75rem;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.18);
        background: rgba(8, 10, 24, 0.54);
        padding: 0.6rem 0.75rem;
    }

    .home-page .live-filter-shell label {
        margin: 0;
        font-size: 0.76rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(215, 220, 248, 0.74);
        white-space: nowrap;
    }

    .home-page .live-filter-shell input {
        flex: 1;
        border: 0;
        outline: 0;
        background: transparent;
        color: #F4F5FF;
    }

    .home-page .event-card {
        height: 100%;
        overflow: hidden;
        position: relative;
        transition: transform 0.32s ease, border-color 0.32s ease, box-shadow 0.32s ease, opacity 0.24s ease;
    }

    .home-page .event-card.is-hidden {
        opacity: 0;
        transform: scale(0.98);
        pointer-events: none;
    }

    .home-page .event-card:hover {
        transform: translateY(-6px);
        border-color: rgba(236, 72, 153, 0.55);
        box-shadow: 0 30px 42px rgba(15, 16, 34, 0.45);
    }

    .home-page .event-card .card-body {
        padding: 1.15rem;
    }

    .home-page.loading .event-card .card-body {
        opacity: 0;
    }

    .home-page .event-card .skeleton-shimmer {
        position: absolute;
        inset: 0;
        z-index: 2;
        opacity: 0;
        pointer-events: none;
        background: linear-gradient(100deg, rgba(255, 255, 255, 0.03) 25%, rgba(255, 255, 255, 0.28) 50%, rgba(255, 255, 255, 0.03) 75%);
        background-size: 220% 100%;
        animation: shimmer 1.3s linear infinite;
    }

    .home-page.loading .event-card .skeleton-shimmer {
        opacity: 1;
    }

    .home-page .sold-out-ribbon {
        position: absolute;
        top: 0.8rem;
        right: -2.45rem;
        z-index: 3;
        background: linear-gradient(100deg, rgba(239, 68, 68, 0.95), rgba(236, 72, 153, 0.9));
        color: #FFFFFF;
        font-size: 0.72rem;
        letter-spacing: 0.06em;
        font-weight: 800;
        padding: 0.27rem 2.8rem;
        transform: rotate(38deg);
        box-shadow: 0 12px 24px rgba(166, 27, 80, 0.42);
        text-transform: uppercase;
    }

    .home-page .event-title {
        margin: 0 0 0.82rem;
        font-family: "Syne", sans-serif;
        font-size: 1.35rem;
        line-height: 1.18;
        color: #F9FAFF;
    }

    .home-page .meta-line {
        margin: 0 0 0.35rem;
        color: rgba(218, 223, 252, 0.78);
    }

    .home-page .meta-line strong {
        color: rgba(246, 247, 255, 0.95);
        font-weight: 700;
    }

    .home-page .category-badge {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        padding: 0.27rem 0.7rem;
        font-size: 0.72rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        color: #FFFFFF;
        margin-bottom: 0.5rem;
        max-width: max-content;
    }

    .home-page .ticket-pill {
        display: inline-flex;
        align-items: center;
        margin: 0.18rem 0 0.9rem;
        border-radius: 999px;
        padding: 0.33rem 0.78rem;
        font-size: 0.82rem;
        color: #F4F7FF;
        border: 1px solid rgba(255, 255, 255, 0.22);
        background: linear-gradient(100deg, rgba(124, 58, 237, 0.42), rgba(37, 99, 235, 0.34), rgba(236, 72, 153, 0.38));
    }

    .home-page .btn-outline-vivid {
        margin-top: auto;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 0.85rem;
        border: 1px solid rgba(236, 72, 153, 0.68);
        color: #F9EFFF;
        text-decoration: none;
        font-weight: 600;
        padding: 0.56rem 0.8rem;
        background: rgba(236, 72, 153, 0.12);
        transition: background-color 0.22s ease, transform 0.22s ease, border-color 0.22s ease;
    }

    .home-page .btn-outline-vivid:hover {
        color: #FFFFFF;
        border-color: rgba(124, 58, 237, 0.95);
        background: rgba(124, 58, 237, 0.28);
        transform: translateY(-1px);
    }

    .home-page .empty-shell {
        padding: 2rem 1.1rem;
        text-align: center;
    }

    .home-page .empty-shell p {
        margin: 0;
        color: rgba(216, 220, 248, 0.8);
    }

    .home-page #liveNoResults {
        display: none;
        margin-top: 0.8rem;
    }

    .home-page #liveNoResults.show {
        display: block;
        animation: fadeInResult 0.28s ease both;
    }

    @keyframes shimmer {
        0% { background-position: 180% 0; }
        100% { background-position: -40% 0; }
    }

    @keyframes fadeInResult {
        from { opacity: 0; transform: translateY(8px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes homeFloat {
        0%, 100% { transform: translateY(0) scale(1); }
        50% { transform: translateY(-12px) scale(1.06); }
    }

    @media (max-width: 767.98px) {
        .home-page .hero-shell,
        .home-page .filter-shell,
        .home-page .event-card,
        .home-page .empty-shell {
            border-radius: 1rem;
        }

        .home-page .event-title {
            font-size: 1.22rem;
        }

        .home-page .live-filter-shell {
            flex-direction: column;
            align-items: stretch;
        }
    }
</style>

<section class="home-page loading" id="homePageRoot">
    <canvas id="homeParticles" class="particle-canvas" aria-hidden="true"></canvas>
    <div class="content-layer">
        <div class="hero-shell">
            <p class="hero-kicker">Immersive Ticketing Platform</p>
            <h1 class="hero-title">Discover unforgettable events</h1>
            <p class="hero-sub">Search by category, city, or date and book experiences through a fast, modern ticketing flow.</p>
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
                                <div class="skeleton-shimmer"></div>
                                <div class="card-body d-flex flex-column">
                                    <span class="category-badge" data-category="${fn:escapeXml(event.category)}"><c:out value="${event.category}"/></span>
                                    <h2 class="event-title"><c:out value="${event.title}"/></h2>
                                    <p class="meta-line"><strong>Location:</strong> <c:out value="${event.location}"/></p>
                                    <p class="meta-line"><strong>Date:</strong> <c:out value="${event.eventDate}"/></p>
                                    <p class="meta-line"><strong>Price:</strong> <fmt:formatNumber value="${event.price}" type="currency"/></p>
                                    <span class="ticket-pill">Available: <c:out value="${event.availableTickets}"/></span>
                                    <a href="${pageContext.request.contextPath}/event?id=${event.id}" class="btn-outline-vivid">View Details</a>
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
    </div>
</section>

<script>
    (function () {
        const homeRoot = document.getElementById("homePageRoot");
        if (!homeRoot) {
            return;
        }

        window.setTimeout(function () {
            homeRoot.classList.remove("loading");
        }, 820);

        const badges = document.querySelectorAll(".category-badge[data-category]");
        badges.forEach(function (badge) {
            const category = (badge.getAttribute("data-category") || "").toLowerCase();
            let hash = 0;
            for (let i = 0; i < category.length; i += 1) {
                hash = category.charCodeAt(i) + ((hash << 5) - hash);
            }
            const hue = Math.abs(hash) % 360;
            const hue2 = (hue + 52) % 360;
            badge.style.background = "linear-gradient(100deg, hsla(" + hue + ", 82%, 58%, 0.84), hsla(" + hue2 + ", 84%, 56%, 0.84))";
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
                    card.classList.toggle("is-hidden", !show);
                    if (show) {
                        visible += 1;
                    }
                });
                if (noResults) {
                    noResults.classList.toggle("show", visible === 0);
                }
            });
        }

        const canvas = document.getElementById("homeParticles");
        if (!canvas || !canvas.getContext || window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
            return;
        }

        const ctx = canvas.getContext("2d");
        const particles = [];
        const total = 42;

        function resize() {
            const rect = homeRoot.getBoundingClientRect();
            canvas.width = Math.max(1, Math.floor(rect.width));
            canvas.height = Math.max(1, Math.floor(rect.height));
        }

        function createParticles() {
            particles.length = 0;
            for (let i = 0; i < total; i += 1) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    vx: (Math.random() - 0.5) * 0.25,
                    vy: (Math.random() - 0.5) * 0.25,
                    r: Math.random() * 1.8 + 0.8
                });
            }
        }

        function draw() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            for (let i = 0; i < particles.length; i += 1) {
                const p = particles[i];
                p.x += p.vx;
                p.y += p.vy;
                if (p.x <= 0 || p.x >= canvas.width) {
                    p.vx *= -1;
                }
                if (p.y <= 0 || p.y >= canvas.height) {
                    p.vy *= -1;
                }

                ctx.beginPath();
                ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
                ctx.fillStyle = "rgba(223, 228, 255, 0.48)";
                ctx.fill();

                for (let j = i + 1; j < particles.length; j += 1) {
                    const q = particles[j];
                    const dx = p.x - q.x;
                    const dy = p.y - q.y;
                    const dist = Math.sqrt(dx * dx + dy * dy);
                    if (dist < 105) {
                        ctx.beginPath();
                        ctx.moveTo(p.x, p.y);
                        ctx.lineTo(q.x, q.y);
                        ctx.strokeStyle = "rgba(130, 137, 210, " + ((105 - dist) / 340) + ")";
                        ctx.lineWidth = 1;
                        ctx.stroke();
                    }
                }
            }
            requestAnimationFrame(draw);
        }

        resize();
        createParticles();
        draw();
        window.addEventListener("resize", function () {
            resize();
            createParticles();
        });
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
