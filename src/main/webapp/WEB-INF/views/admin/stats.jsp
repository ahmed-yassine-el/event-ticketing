<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin Statistics"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-stats .glass-card {
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

    .kpi-role {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .empty-state {
        border: 1px dashed #CBD5E1;
        border-radius: 12px;
        padding: 0.9rem;
        color: #64748B;
    }
</style>

<section class="admin-stats dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Admin</h2>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/events">Events</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/admin/users">Users</a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/admin/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="row g-4 mb-4">
            <div class="col-md-3"><div class="metric-card kpi-card primary"><p class="metric-label">Total Users</p><h3 class="metric-value"><c:out value="${summary.totalUsers}"/></h3></div></div>
            <div class="col-md-3"><div class="metric-card kpi-card info"><p class="metric-label">Total Events</p><h3 class="metric-value"><c:out value="${summary.totalEvents}"/></h3></div></div>
            <div class="col-md-3"><div class="metric-card kpi-card warning"><p class="metric-label">Total Tickets</p><h3 class="metric-value"><c:out value="${summary.totalTickets}"/></h3></div></div>
            <div class="col-md-3"><div class="metric-card kpi-card success"><p class="metric-label">Total Revenue</p><h3 class="metric-value"><fmt:formatNumber value="${summary.totalRevenue}" type="currency"/></h3></div></div>
        </div>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="glass-card card h-100">
                    <div class="card-body">
                        <h2 class="section-title">Most Popular Events</h2>
                        <c:choose>
                            <c:when test="${not empty popularEvents}">
                                <ul class="popular-list">
                                    <c:forEach items="${popularEvents}" var="event" varStatus="status">
                                        <c:set var="soldPercent" value="${event.totalTickets > 0 ? (event.soldTickets * 100.0 / event.totalTickets) : 0}"/>
                                        <li class="popular-item">
                                            <div class="popular-top">
                                                <c:choose>
                                                    <c:when test="${status.count == 1}"><span class="rank-chip gold">Top 1</span></c:when>
                                                    <c:when test="${status.count == 2}"><span class="rank-chip silver">Top 2</span></c:when>
                                                    <c:when test="${status.count == 3}"><span class="rank-chip bronze">Top 3</span></c:when>
                                                    <c:otherwise><span class="rank-chip">#<c:out value="${status.count}"/></span></c:otherwise>
                                                </c:choose>
                                                <span class="category-pill" data-category="${fn:escapeXml(event.category)}">
                                                    <c:out value="${event.category}"/>
                                                </span>
                                            </div>
                                            <p class="event-title"><c:out value="${event.title}"/></p>
                                            <div class="metrics-row">
                                                <span>Sold: <strong><c:out value="${event.soldTickets}"/></strong> / <c:out value="${event.totalTickets}"/></span>
                                                <span class="revenue"><fmt:formatNumber value="${event.revenue}" type="currency"/></span>
                                            </div>
                                            <div class="progress">
                                                <div class="progress-bar" role="progressbar" style="width: ${soldPercent > 100 ? 100 : soldPercent}%;"></div>
                                            </div>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">No sales data available yet.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <div class="col-lg-6">
                <div class="glass-card card h-100">
                    <div class="card-body">
                        <h2 class="section-title">User Registrations</h2>
                        <div class="chart-wrap mb-3">
                            <canvas id="registrationsChart" height="220"></canvas>
                        </div>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="metric-card primary">
                                    <p class="metric-label kpi-role">Total Participants</p>
                                    <h3 class="metric-value"><c:out value="${totalParticipants}"/></h3>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="metric-card info">
                                    <p class="metric-label kpi-role">Total Organizers</p>
                                    <h3 class="metric-value"><c:out value="${totalOrganizers}"/></h3>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="metric-card warning">
                                    <p class="metric-label kpi-role">Total Admins</p>
                                    <h3 class="metric-value"><c:out value="${totalAdmins}"/></h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<script>
    const registrationRows = [
        <c:forEach items="${registrationStats}" var="stat" varStatus="status">
        {date: "${fn:escapeXml(stat.date)}", role: "${fn:escapeXml(stat.role)}", count: ${stat.registrations}}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const dateSet = new Set();
    const participantByDate = {};
    const organizerByDate = {};
    registrationRows.forEach(function (row) {
        dateSet.add(row.date);
        if (row.role === "PARTICIPANT") {
            participantByDate[row.date] = (participantByDate[row.date] || 0) + row.count;
        }
        if (row.role === "ORGANIZER") {
            organizerByDate[row.date] = (organizerByDate[row.date] || 0) + row.count;
        }
    });

    const registrationLabels = Array.from(dateSet).sort();
    const participantSeries = registrationLabels.map(function (label) {
        return participantByDate[label] || 0;
    });
    const organizerSeries = registrationLabels.map(function (label) {
        return organizerByDate[label] || 0;
    });

    const registrationCanvas = document.getElementById("registrationsChart");
    const registrationCtx = registrationCanvas.getContext("2d");
    const participantGradient = registrationCtx.createLinearGradient(0, 0, 0, registrationCanvas.height || 220);
    participantGradient.addColorStop(0, "rgba(255, 107, 53, 0.38)");
    participantGradient.addColorStop(1, "rgba(255, 107, 53, 0.05)");
    const organizerGradient = registrationCtx.createLinearGradient(0, 0, 0, registrationCanvas.height || 220);
    organizerGradient.addColorStop(0, "rgba(56, 178, 172, 0.38)");
    organizerGradient.addColorStop(1, "rgba(56, 178, 172, 0.05)");

    new Chart(registrationCanvas, {
        type: "line",
        data: {
            labels: registrationLabels,
            datasets: [{
                label: "Participants",
                data: participantSeries,
                borderColor: "rgba(255, 107, 53, 0.95)",
                backgroundColor: participantGradient,
                pointBackgroundColor: "rgba(255, 107, 53, 1)",
                pointBorderColor: "#FFFFFF",
                pointBorderWidth: 1,
                tension: 0.28,
                fill: true
            }, {
                label: "Organizers",
                data: organizerSeries,
                borderColor: "rgba(56, 178, 172, 0.95)",
                backgroundColor: organizerGradient,
                pointBackgroundColor: "rgba(56, 178, 172, 1)",
                pointBorderColor: "#FFFFFF",
                pointBorderWidth: 1,
                tension: 0.28,
                fill: true
            }]
        },
        options: {
            responsive: true,
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
            },
            plugins: {
                legend: {
                    labels: { color: "#334155" }
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
