<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Organizer Stats"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .organizer-stats {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .organizer-stats .glass-card {
        border-radius: 1.2rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 28px 46px rgba(7, 8, 20, 0.4);
        height: 100%;
    }

    .organizer-stats .glass-card .card-body {
        padding: 1.1rem;
    }

    .organizer-stats .block-title {
        margin: 0 0 0.9rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.2rem, 3vw, 1.5rem);
        line-height: 1.12;
        color: #F7F8FF;
    }

    .organizer-stats .chart-wrap {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.14);
        background: rgba(8, 10, 24, 0.58);
        padding: 0.75rem;
    }

    .organizer-stats .popular-list {
        list-style: none;
        margin: 0;
        padding: 0;
        display: grid;
        gap: 0.6rem;
    }

    .organizer-stats .popular-item {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 0.7rem;
        border-radius: 0.9rem;
        border: 1px solid rgba(255, 255, 255, 0.15);
        background: rgba(8, 10, 24, 0.62);
        padding: 0.72rem 0.78rem;
        color: #EEF0FF;
    }

    .organizer-stats .popular-badge {
        display: inline-flex;
        align-items: center;
        border-radius: 999px;
        border: 1px solid rgba(124, 58, 237, 0.7);
        background: rgba(124, 58, 237, 0.25);
        color: #EFE3FF;
        font-size: 0.74rem;
        font-weight: 700;
        letter-spacing: 0.04em;
        padding: 0.22rem 0.6rem;
    }
</style>

<section class="organizer-stats">
    <div class="row g-4">
        <div class="col-lg-7">
            <div class="glass-card card">
                <div class="card-body">
                    <h2 class="block-title">Tickets Sold By Your Events</h2>
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
                    <ul class="popular-list">
                        <c:forEach items="${popularEvents}" var="item">
                            <li class="popular-item">
                                <span><c:out value="${item.title}"/></span>
                                <span class="popular-badge"><c:out value="${item.soldTickets}"/></span>
                            </li>
                        </c:forEach>
                    </ul>
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

    const soldCanvas = document.getElementById('soldByEventChart');
    const soldCtx = soldCanvas.getContext('2d');
    const soldGradient = soldCtx.createLinearGradient(0, 0, 0, soldCanvas.height || 180);
    soldGradient.addColorStop(0, 'rgba(124, 58, 237, 0.95)');
    soldGradient.addColorStop(0.5, 'rgba(37, 99, 235, 0.88)');
    soldGradient.addColorStop(1, 'rgba(236, 72, 153, 0.78)');

    new Chart(soldCanvas, {
        type: 'bar',
        data: {
            labels: soldLabels,
            datasets: [{
                label: 'Tickets Sold',
                data: soldValues,
                backgroundColor: soldGradient,
                borderColor: 'rgba(255, 255, 255, 0.25)',
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
                    ticks: {
                        color: 'rgba(222, 227, 252, 0.82)'
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.08)'
                    }
                },
                y: {
                    beginAtZero: true,
                    ticks: {
                        color: 'rgba(222, 227, 252, 0.82)'
                    },
                    grid: {
                        color: 'rgba(255, 255, 255, 0.08)'
                    }
                }
            }
        }
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
