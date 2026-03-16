<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Organizer Stats"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .organizer-stats .glass-card {
        padding: 0.2rem;
    }

    .chart-wrap {
        border: 1px solid #E2E8F0;
        border-radius: 14px;
        padding: 0.65rem;
        background: #FFFFFF;
    }

    .popular-list {
        list-style: none;
        padding: 0;
        margin: 0;
        display: grid;
        gap: 0.75rem;
    }

    .popular-item {
        border: 1px solid #E2E8F0;
        border-radius: 14px;
        padding: 0.75rem;
        background: #FFFFFF;
    }

    .popular-top {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.5rem;
        margin-bottom: 0.45rem;
    }

    .rank-chip {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border-radius: 999px;
        padding: 0.2rem 0.62rem;
        font-size: 0.7rem;
        text-transform: uppercase;
        letter-spacing: 0.06em;
        font-weight: 700;
        border: 1px solid #E2E8F0;
        color: #475569;
        background: #FFFFFF;
    }

    .rank-chip.gold { background: #FFF7D6; border-color: #FDE68A; color: #92400E; }
    .rank-chip.silver { background: #F1F5F9; border-color: #CBD5E1; color: #334155; }
    .rank-chip.bronze { background: #FFEDD5; border-color: #FDBA74; color: #9A3412; }

    .event-title {
        margin: 0;
        font-size: 1.15rem;
        color: #2D3748;
    }

    .metrics-row {
        margin-top: 0.35rem;
        display: flex;
        justify-content: space-between;
        gap: 0.4rem;
        flex-wrap: wrap;
        color: #4A5568;
        font-size: 0.88rem;
    }

    .progress {
        margin-top: 0.5rem;
        height: 8px;
        background: #F1F5F9;
        border-radius: 999px;
        overflow: hidden;
    }

    .progress-bar {
        background: linear-gradient(90deg, #FF6B35, #38B2AC);
    }

    .empty-state {
        border: 1px dashed #CBD5E1;
        border-radius: 12px;
        padding: 0.9rem;
        color: #64748B;
    }
</style>

<section class="organizer-stats dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Organizer</h2>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/create-event">Create Event</a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/organizer/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="row g-4">
            <div class="col-lg-7">
                <div class="glass-card card">
                    <div class="card-body">
                        <h2 class="block-title">Tickets Sold by Event</h2>
                        <div class="chart-wrap">
                            <canvas id="soldByEventChart" height="180"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-5">
                <div class="glass-card card">
                    <div class="card-body">
                        <h2 class="block-title">Most Popular Events</h2>
                        <c:choose>
                            <c:when test="${not empty popularEvents}">
                                <ul class="popular-list">
                                    <c:forEach items="${popularEvents}" var="item" varStatus="status">
                                        <c:set var="soldPercent" value="${item.totalTickets > 0 ? (item.soldTickets * 100.0 / item.totalTickets) : 0}"/>
                                        <li class="popular-item">
                                            <div class="popular-top">
                                                <c:choose>
                                                    <c:when test="${status.count == 1}"><span class="rank-chip gold">Top 1</span></c:when>
                                                    <c:when test="${status.count == 2}"><span class="rank-chip silver">Top 2</span></c:when>
                                                    <c:when test="${status.count == 3}"><span class="rank-chip bronze">Top 3</span></c:when>
                                                    <c:otherwise><span class="rank-chip">#<c:out value="${status.count}"/></span></c:otherwise>
                                                </c:choose>
                                                <span class="category-pill" data-category="${fn:escapeXml(item.category)}">
                                                    <c:out value="${item.category}"/>
                                                </span>
                                            </div>
                                            <p class="event-title"><c:out value="${item.title}"/></p>
                                            <div class="metrics-row">
                                                <span>Sold: <strong><c:out value="${item.soldTickets}"/></strong> / <c:out value="${item.totalTickets}"/></span>
                                                <span class="revenue"><fmt:formatNumber value="${item.revenue}" type="currency"/></span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar" role="progressbar" style="width: ${soldPercent > 100 ? 100 : soldPercent}%;"></div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">No sold tickets yet. Popular events will appear here once sales start.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    const soldLabels = [
        <c:forEach items="${soldByEvent}" var="entry" varStatus="status">"${fn:escapeXml(entry.key)}"<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const soldValues = [
        <c:forEach items="${soldByEvent}" var="entry" varStatus="status">${entry.value}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    const soldCanvas = document.getElementById("soldByEventChart");
    const soldCtx = soldCanvas.getContext("2d");
    const soldGradient = soldCtx.createLinearGradient(0, 0, 0, soldCanvas.height || 180);
    soldGradient.addColorStop(0, "rgba(255, 107, 53, 0.92)");
    soldGradient.addColorStop(1, "rgba(56, 178, 172, 0.82)");

    new Chart(soldCanvas, {
        type: "bar",
        data: {
            labels: soldLabels,
            datasets: [{
                label: "Tickets Sold",
                data: soldValues,
                backgroundColor: soldGradient,
                borderColor: "rgba(255, 107, 53, 1)",
                borderWidth: 1,
                borderRadius: 10
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    ticks: { color: "#4A5568" },
                    grid: { color: "rgba(148, 163, 184, 0.18)" }
                },
                y: {
                    beginAtZero: true,
                    ticks: { color: "#4A5568" },
                    grid: { color: "rgba(148, 163, 184, 0.18)" }
                }
            }
        }
    });

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
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
