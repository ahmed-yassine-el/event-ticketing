<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Admin Statistics"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .admin-stats {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .admin-stats .metric-card,
    .admin-stats .glass-card {
        border-radius: 1.2rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 26px 44px rgba(7, 8, 20, 0.4);
        height: 100%;
    }

    .admin-stats .metric-card {
        padding: 0.95rem;
    }

    .admin-stats .metric-label {
        margin: 0;
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(215, 220, 248, 0.74);
    }

    .admin-stats .metric-value {
        margin: 0.42rem 0 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.35rem, 3vw, 1.95rem);
        line-height: 1.1;
        color: #F8F9FF;
    }

    .admin-stats .metric-card.primary {
        background: linear-gradient(135deg, rgba(124, 58, 237, 0.3), rgba(37, 99, 235, 0.2));
    }

    .admin-stats .metric-card.info {
        background: linear-gradient(135deg, rgba(37, 99, 235, 0.3), rgba(14, 165, 233, 0.2));
    }

    .admin-stats .metric-card.warning {
        background: linear-gradient(135deg, rgba(245, 158, 11, 0.3), rgba(251, 191, 36, 0.2));
    }

    .admin-stats .metric-card.success {
        background: linear-gradient(135deg, rgba(34, 197, 94, 0.28), rgba(37, 99, 235, 0.2));
    }

    .admin-stats .glass-card .card-body {
        padding: 1.1rem;
    }

    .admin-stats .section-title {
        margin: 0 0 0.85rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.2rem, 3vw, 1.52rem);
        line-height: 1.1;
        color: #F7F8FF;
    }

    .admin-stats .chart-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.14);
        background: rgba(8, 10, 24, 0.58);
        padding: 0.75rem;
    }

    .admin-stats .table-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.16);
        overflow: hidden;
        background: rgba(8, 10, 24, 0.58);
    }

    .admin-stats .popular-table {
        margin: 0;
        --bs-table-bg: transparent;
        --bs-table-striped-bg: rgba(255, 255, 255, 0.04);
        --bs-table-striped-color: #EEF1FF;
        color: #EEF1FF;
    }

    .admin-stats .popular-table thead th {
        background: rgba(255, 255, 255, 0.05);
        border-bottom: 1px solid rgba(255, 255, 255, 0.16);
        color: rgba(215, 220, 248, 0.78);
        font-size: 0.75rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        white-space: nowrap;
    }

    .admin-stats .popular-table td,
    .admin-stats .popular-table th {
        border-color: rgba(255, 255, 255, 0.08);
        padding: 0.78rem 0.68rem;
        vertical-align: middle;
    }

    .admin-stats .sold-pill {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(124, 58, 237, 0.66);
        background: rgba(124, 58, 237, 0.25);
        color: #F1E8FF;
        font-size: 0.72rem;
        font-weight: 700;
        letter-spacing: 0.04em;
        padding: 0.24rem 0.6rem;
    }

    @media (max-width: 991.98px) {
        .admin-stats .table-wrap {
            overflow-x: auto;
        }

        .admin-stats .popular-table {
            min-width: 520px;
        }
    }
</style>

<section class="admin-stats">
    <div class="row g-4 mb-4">
        <div class="col-md-3"><div class="metric-card kpi-card primary"><p class="metric-label">Total Users</p><h3 class="metric-value"><c:out value="${summary.totalUsers}"/></h3></div></div>
        <div class="col-md-3"><div class="metric-card kpi-card info"><p class="metric-label">Total Events</p><h3 class="metric-value"><c:out value="${summary.totalEvents}"/></h3></div></div>
        <div class="col-md-3"><div class="metric-card kpi-card warning"><p class="metric-label">Total Tickets</p><h3 class="metric-value"><c:out value="${summary.totalTickets}"/></h3></div></div>
        <div class="col-md-3"><div class="metric-card kpi-card success"><p class="metric-label">Total Revenue</p><h3 class="metric-value"><fmt:formatNumber value="${summary.totalRevenue}" type="currency"/></h3></div></div>
    </div>

    <div class="row g-4">
        <div class="col-lg-6">
            <div class="glass-card card">
                <div class="card-body">
                    <h2 class="section-title">Most Popular Events</h2>
                    <div class="chart-wrap">
                        <canvas id="popularEventsChart" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6">
            <div class="glass-card card">
                <div class="card-body">
                    <h2 class="section-title">User Registrations</h2>
                    <div class="chart-wrap">
                        <canvas id="registrationsChart" height="200"></canvas>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="glass-card card mt-4">
        <div class="card-body">
            <h2 class="section-title">Popular Events Table</h2>
            <div class="table-wrap table-responsive">
                <table class="table table-striped align-middle popular-table">
                    <thead>
                    <tr><th>Event</th><th>Tickets Sold</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${popularEvents}" var="event">
                        <tr>
                            <td><c:out value="${event.title}"/></td>
                            <td><span class="sold-pill"><c:out value="${event.soldTickets}"/></span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</section>

<script>
    const popularLabels = [
        <c:forEach items="${popularEvents}" var="event" varStatus="status">"${fn:escapeXml(event.title)}"<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const popularData = [
        <c:forEach items="${popularEvents}" var="event" varStatus="status">${event.soldTickets}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    const registrationLabels = [
        <c:forEach items="${registrationStats}" var="stat" varStatus="status">"${fn:escapeXml(stat.date)}"<c:if test="${!status.last}">,</c:if></c:forEach>
    ];
    const registrationData = [
        <c:forEach items="${registrationStats}" var="stat" varStatus="status">${stat.registrations}<c:if test="${!status.last}">,</c:if></c:forEach>
    ];

    const popularCanvas = document.getElementById('popularEventsChart');
    const popularCtx = popularCanvas.getContext('2d');
    const popularGradient = popularCtx.createLinearGradient(0, 0, 0, popularCanvas.height || 200);
    popularGradient.addColorStop(0, 'rgba(124, 58, 237, 0.95)');
    popularGradient.addColorStop(0.5, 'rgba(37, 99, 235, 0.9)');
    popularGradient.addColorStop(1, 'rgba(236, 72, 153, 0.78)');

    new Chart(popularCanvas, {
        type: 'bar',
        data: {
            labels: popularLabels,
            datasets: [{
                label: 'Tickets Sold',
                data: popularData,
                backgroundColor: popularGradient,
                borderColor: 'rgba(255, 255, 255, 0.22)',
                borderWidth: 1,
                borderRadius: 10
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    ticks: { color: 'rgba(222, 227, 252, 0.82)' },
                    grid: { color: 'rgba(255, 255, 255, 0.08)' }
                },
                y: {
                    beginAtZero: true,
                    ticks: { color: 'rgba(222, 227, 252, 0.82)' },
                    grid: { color: 'rgba(255, 255, 255, 0.08)' }
                }
            },
            plugins: {
                legend: {
                    labels: { color: 'rgba(236, 239, 255, 0.86)' }
                }
            }
        }
    });

    const registrationsCanvas = document.getElementById('registrationsChart');
    const registrationsCtx = registrationsCanvas.getContext('2d');
    const registrationsGradient = registrationsCtx.createLinearGradient(0, 0, 0, registrationsCanvas.height || 200);
    registrationsGradient.addColorStop(0, 'rgba(236, 72, 153, 0.55)');
    registrationsGradient.addColorStop(1, 'rgba(124, 58, 237, 0)');

    new Chart(registrationsCanvas, {
        type: 'line',
        data: {
            labels: registrationLabels,
            datasets: [{
                label: 'Registrations',
                data: registrationData,
                borderColor: 'rgba(236, 72, 153, 0.95)',
                backgroundColor: registrationsGradient,
                fill: true,
                tension: 0.25,
                pointBackgroundColor: 'rgba(37, 99, 235, 0.95)',
                pointBorderColor: '#FFFFFF',
                pointBorderWidth: 1.2
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    ticks: { color: 'rgba(222, 227, 252, 0.82)' },
                    grid: { color: 'rgba(255, 255, 255, 0.08)' }
                },
                y: {
                    beginAtZero: true,
                    ticks: { color: 'rgba(222, 227, 252, 0.82)' },
                    grid: { color: 'rgba(255, 255, 255, 0.08)' }
                }
            },
            plugins: {
                legend: {
                    labels: { color: 'rgba(236, 239, 255, 0.86)' }
                }
            }
        }
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
