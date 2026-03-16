<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="isAuthPage" value="${pageTitle == 'Login' or pageTitle == 'Register'}"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${empty pageTitle ? 'Event Ticketing' : pageTitle}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600;700;800&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <c:if test="${pageTitle == 'Create Event' or pageTitle == 'Edit Event' or pageTitle == 'Event Details'}">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    </c:if>
    <style>
        :root {
            --bg: #FAFAFA;
            --surface: #FFFFFF;
            --primary: #FF6B35;
            --secondary: #2D3748;
            --accent: #38B2AC;
            --text: #1A202C;
            --muted: #4A5568;
            --border: #E2E8F0;
            --shadow-soft: 0 18px 42px rgba(26, 32, 44, 0.08);
            --shadow-card: 0 12px 26px rgba(45, 55, 72, 0.09);
            --radius-lg: 20px;
            --radius-md: 14px;
            --radius-sm: 10px;
        }

        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            background: var(--bg);
            color: var(--text);
            font-family: "Plus Jakarta Sans", sans-serif;
        }

        body.app-shell {
            position: relative;
            overflow-x: hidden;
            animation: pageFadeIn 0.45s ease;
        }

        body.app-shell::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: -1;
            background:
                radial-gradient(circle at 10% 8%, rgba(255, 107, 53, 0.08), transparent 30%),
                radial-gradient(circle at 90% 16%, rgba(56, 178, 172, 0.08), transparent 28%),
                linear-gradient(180deg, #FFFFFF 0%, #FAFAFA 68%);
        }

        @keyframes pageFadeIn {
            from {
                opacity: 0;
                transform: translateY(6px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        #pageProgress {
            position: fixed;
            top: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--primary), #FF8F66);
            z-index: 1200;
            transition: width 0.4s ease;
        }

        .shell-nav {
            position: sticky;
            top: 0;
            z-index: 1100;
            background: rgba(255, 255, 255, 0.96);
            border-bottom: 1px solid rgba(226, 232, 240, 0.9);
            box-shadow: 0 10px 24px rgba(45, 55, 72, 0.05);
            backdrop-filter: blur(10px);
        }

        .shell-nav-inner {
            max-width: 1240px;
            width: calc(100% - 1.5rem);
        }

        .shell-brand {
            font-family: "Playfair Display", serif;
            font-weight: 800;
            letter-spacing: 0.02em;
            font-size: 1.7rem;
            color: var(--primary) !important;
            text-decoration: none;
        }

        .shell-toggler {
            border: 1px solid var(--border) !important;
            color: var(--secondary) !important;
            box-shadow: none !important;
        }

        .shell-toggler .navbar-toggler-icon {
            filter: invert(18%) sepia(11%) saturate(1400%) hue-rotate(179deg) brightness(90%) contrast(90%);
        }

        .shell-links {
            gap: 0.2rem;
        }

        .shell-link.nav-link {
            color: var(--secondary) !important;
            font-weight: 600;
            padding: 0.55rem 0.88rem !important;
            border-radius: 999px;
            position: relative;
            transition: color 0.25s ease;
        }

        .shell-link.nav-link::after {
            content: "";
            position: absolute;
            left: 0.78rem;
            right: 0.78rem;
            bottom: 0.35rem;
            height: 2px;
            border-radius: 2px;
            background: var(--primary);
            transform: scaleX(0);
            transform-origin: left center;
            transition: transform 0.24s ease;
        }

        .shell-link.nav-link:hover,
        .shell-link.nav-link:focus,
        .shell-link.nav-link.active-route {
            color: var(--primary) !important;
        }

        .shell-link.nav-link:hover::after,
        .shell-link.nav-link:focus::after,
        .shell-link.nav-link.active-route::after {
            transform: scaleX(1);
        }

        .nav-clock {
            display: inline-block;
            min-width: 112px;
            text-align: center;
            border: 1px solid rgba(255, 107, 53, 0.3);
            background: #FFF6F1;
            color: var(--secondary);
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.36rem 0.7rem;
        }

        main.container.py-4 {
            max-width: 1240px !important;
            width: calc(100% - 1.5rem);
            padding-top: 1.1rem !important;
            padding-bottom: 2.2rem !important;
        }

        main.container.py-4.auth-main {
            max-width: 100% !important;
            width: 100%;
            padding: 0 !important;
        }

        .app-breadcrumb-wrap {
            margin-bottom: 1.25rem;
        }

        .app-breadcrumb {
            padding: 0.5rem 0.85rem;
            border: 1px solid var(--border);
            background: #FFFFFF;
            border-radius: 999px;
            margin: 0;
        }

        .app-breadcrumb .breadcrumb-item,
        .app-breadcrumb .breadcrumb-item a {
            color: var(--muted);
            font-size: 0.86rem;
            text-decoration: none;
        }

        .app-breadcrumb .breadcrumb-item.active {
            color: var(--primary);
            font-weight: 700;
        }

        .server-toast-data {
            display: none;
        }

        .card,
        .glass-card,
        .glass-panel,
        .form-shell,
        .detail-shell,
        .tickets-shell,
        .error-shell,
        .hero-shell,
        .filter-shell {
            background: var(--surface) !important;
            border: 1px solid var(--border) !important;
            border-radius: var(--radius-lg) !important;
            box-shadow: var(--shadow-card) !important;
            color: var(--text);
        }

        h1, h2, h3, h4, h5 {
            font-family: "Playfair Display", serif;
            color: var(--secondary);
            letter-spacing: 0.01em;
        }

        .section-title,
        .form-title,
        .tickets-title,
        .detail-title,
        .block-title {
            font-family: "Playfair Display", serif;
            color: var(--secondary);
        }

        .btn-vivid,
        .btn-approve,
        .btn-modal-primary,
        .btn-confirm-delete,
        .btn-pill,
        .btn-outline-vivid,
        .btn-soft,
        .btn-subtle {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.3rem;
            border-radius: 999px;
            font-weight: 700;
            line-height: 1.1;
            border: 1px solid transparent;
            text-decoration: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background-color 0.2s ease;
        }

        .btn-vivid,
        .btn-approve,
        .btn-modal-primary,
        .btn-confirm-delete {
            background: var(--primary);
            color: #FFFFFF;
            border-color: var(--primary);
            box-shadow: 0 10px 20px rgba(255, 107, 53, 0.24);
            padding: 0.68rem 1.25rem;
        }

        .btn-vivid:hover,
        .btn-approve:hover,
        .btn-modal-primary:hover,
        .btn-confirm-delete:hover {
            transform: scale(1.02);
            color: #FFFFFF;
            background: #F75A1E;
            border-color: #F75A1E;
        }

        .btn-soft,
        .btn-subtle,
        .btn-outline-vivid,
        .btn-modal-secondary,
        .btn-cancel,
        .btn-delete,
        .btn-danger-soft,
        .btn-transfer,
        .btn-show-qr,
        .btn-qr {
            background: #FFFFFF;
            color: var(--secondary);
            border: 1px solid var(--border);
            padding: 0.56rem 1rem;
            border-radius: 999px;
            font-weight: 700;
            text-decoration: none;
            transition: transform 0.2s ease, border-color 0.2s ease, color 0.2s ease, box-shadow 0.2s ease;
        }

        .btn-soft:hover,
        .btn-subtle:hover,
        .btn-outline-vivid:hover,
        .btn-modal-secondary:hover,
        .btn-cancel:hover,
        .btn-delete:hover,
        .btn-danger-soft:hover,
        .btn-transfer:hover,
        .btn-show-qr:hover,
        .btn-qr:hover {
            color: var(--primary);
            border-color: rgba(255, 107, 53, 0.6);
            box-shadow: 0 8px 18px rgba(255, 107, 53, 0.16);
            transform: scale(1.01);
        }

        .btn-reject,
        .btn-danger-soft,
        .btn-cancel,
        .btn-modal-danger {
            border-color: #FECACA !important;
            color: #B91C1C !important;
            background: #FFF5F5 !important;
        }

        .btn-reject:hover,
        .btn-danger-soft:hover,
        .btn-cancel:hover,
        .btn-modal-danger:hover {
            background: #FEE2E2 !important;
            color: #991B1B !important;
            border-color: #FCA5A5 !important;
        }

        .form-label {
            font-size: 0.8rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--muted);
            font-weight: 700;
        }

        .form-control,
        .form-select {
            min-height: 44px;
            border-radius: 12px;
            border: 1px solid #D6DEE8;
            color: var(--text);
            background: #FFFFFF;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: rgba(255, 107, 53, 0.7);
            box-shadow: 0 0 0 3px rgba(255, 107, 53, 0.14);
        }

        .metric-card {
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-top: 4px solid var(--primary);
            border-radius: 16px;
            padding: 1rem;
            box-shadow: var(--shadow-card);
        }

        .metric-card.info {
            border-top-color: var(--accent);
        }

        .metric-card.success {
            border-top-color: #22C55E;
        }

        .metric-card.warning {
            border-top-color: #F59E0B;
        }

        .metric-label {
            margin: 0;
            font-size: 0.78rem;
            color: var(--muted);
            text-transform: uppercase;
            letter-spacing: 0.09em;
            font-weight: 700;
        }

        .metric-value {
            margin: 0.35rem 0 0;
            font-family: "Playfair Display", serif;
            color: var(--secondary);
            font-size: 1.9rem;
        }

        .table {
            --bs-table-bg: #FFFFFF;
            --bs-table-color: var(--text);
            --bs-table-border-color: #E2E8F0;
        }

        .table thead th {
            font-size: 0.74rem;
            text-transform: uppercase;
            letter-spacing: 0.09em;
            color: #4A5568;
            border-bottom-width: 1px;
            background: #F8FAFC;
        }

        .table tbody td {
            padding-top: 0.72rem;
            padding-bottom: 0.72rem;
            vertical-align: middle;
            border-color: #EDF2F7;
        }

        .table tbody tr:nth-child(even) td {
            background: #FBFDFF;
        }

        .table tbody tr:hover td {
            background: #FFF8F4;
        }

        .status-pill,
        .role-pill,
        .ticket-pill,
        .category-badge,
        .category-pill {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 999px;
            padding: 0.27rem 0.72rem;
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .status-active,
        .status-approved {
            background: #DCFCE7;
            color: #166534;
        }

        .status-inactive,
        .status-cancelled,
        .status.cancelled {
            background: #FEE2E2;
            color: #991B1B;
        }

        .status-pending,
        .status.pending {
            background: #FEF3C7;
            color: #92400E;
        }

        .status-pill.approved {
            background: #DCFCE7;
            color: #166534;
        }

        .status-pill.pending {
            background: #FEF3C7;
            color: #92400E;
        }

        .status-pill.cancelled {
            background: #FEE2E2;
            color: #991B1B;
        }

        .ticket-pill,
        .price-pill {
            background: #E6FFFA;
            color: #0F766E;
        }

        .category-badge,
        .category-pill,
        .role-pill {
            background: #FFF1EA;
            color: #C2410C;
            border: 1px solid #FFD5C4;
        }

        .actions,
        .btn-row {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.45rem;
        }

        .modal-content {
            border-radius: 16px;
            border: 1px solid #E2E8F0;
            box-shadow: var(--shadow-soft);
        }

        .modal-header,
        .modal-footer {
            border-color: #EEF2F7;
        }

        .modal-title {
            font-family: "Playfair Display", serif;
            color: var(--secondary);
        }

        .app-toast-stack {
            position: fixed;
            top: 72px;
            right: 14px;
            z-index: 1205;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            pointer-events: none;
        }

        .app-toast {
            min-width: 220px;
            max-width: 320px;
            padding: 0.72rem 0.9rem;
            border-radius: 12px;
            border: 1px solid #E2E8F0;
            background: #FFFFFF;
            color: var(--text);
            box-shadow: var(--shadow-card);
            animation: toastIn 0.25s ease;
        }

        .app-toast.success {
            border-left: 4px solid #16A34A;
        }

        .app-toast.error {
            border-left: 4px solid #DC2626;
        }

        .app-toast.out {
            opacity: 0;
            transform: translateY(-6px);
            transition: 0.25s ease;
        }

        @keyframes toastIn {
            from {
                opacity: 0;
                transform: translateY(-8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        #backToTop {
            position: fixed;
            right: 16px;
            bottom: 16px;
            width: 42px;
            height: 42px;
            border: none;
            border-radius: 999px;
            background: var(--primary);
            color: #FFFFFF;
            font-weight: 700;
            box-shadow: 0 12px 22px rgba(255, 107, 53, 0.32);
            opacity: 0;
            transform: translateY(10px);
            pointer-events: none;
            transition: 0.2s ease;
            z-index: 999;
        }

        #backToTop.show {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }

        .shell-footer {
            margin-top: 2.4rem;
            border-top: 1px solid #E2E8F0;
            background: #FFFFFF;
        }

        .shell-footer-inner {
            max-width: 1240px;
            width: calc(100% - 1.5rem);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 0.6rem;
            padding-top: 0.25rem;
            padding-bottom: 0.25rem;
        }

        .shell-copy,
        .shell-stack {
            margin: 0;
            color: #64748B;
            font-size: 0.88rem;
        }

        .shell-copy strong {
            color: var(--primary);
            font-family: "Playfair Display", serif;
        }

        .dashboard-layout {
            display: grid;
            grid-template-columns: 260px minmax(0, 1fr);
            gap: 1rem;
            align-items: start;
        }

        .dashboard-sidebar {
            position: sticky;
            top: 86px;
            background: #FFFFFF;
            border: 1px solid #E2E8F0;
            border-radius: 18px;
            box-shadow: var(--shadow-card);
            padding: 0.8rem;
        }

        .dashboard-sidebar h2 {
            font-size: 1.08rem;
            margin: 0 0 0.65rem;
            color: var(--secondary);
        }

        .sidebar-link {
            display: block;
            width: 100%;
            padding: 0.62rem 0.75rem;
            border-radius: 10px;
            color: var(--secondary);
            text-decoration: none;
            font-weight: 600;
            border: 1px solid transparent;
            margin-bottom: 0.34rem;
            transition: 0.2s ease;
        }

        .sidebar-link:hover {
            background: #FFF5F0;
            color: var(--primary);
        }

        .sidebar-link.active {
            background: #FFF1EA;
            color: var(--primary);
            border-color: #FFD3C0;
        }

        .dashboard-content {
            min-width: 0;
        }

        .card,
        .metric-card,
        .event-card,
        .popular-item,
        .detail-shell,
        .form-shell,
        .tickets-shell,
        .error-shell {
            transition: transform 0.22s ease, box-shadow 0.22s ease;
        }

        .card:hover,
        .metric-card:hover,
        .event-card:hover,
        .popular-item:hover,
        .detail-shell:hover,
        .form-shell:hover,
        .tickets-shell:hover,
        .error-shell:hover {
            transform: translateY(-4px);
            box-shadow: 0 20px 34px rgba(45, 55, 72, 0.11);
        }

        .pagination .page-link {
            color: var(--secondary);
            border-color: #E2E8F0;
            border-radius: 10px;
            margin: 0 0.15rem;
        }

        .pagination .page-item.active .page-link {
            background: var(--primary);
            border-color: var(--primary);
            color: #FFFFFF;
        }

        @media (max-width: 991.98px) {
            .shell-nav-inner,
            main.container.py-4 {
                width: calc(100% - 1rem);
            }

            .dashboard-layout {
                grid-template-columns: 1fr;
            }

            .dashboard-sidebar {
                position: static;
            }

            #navMain {
                margin-top: 0.7rem;
                border-top: 1px solid #E2E8F0;
                padding-top: 0.75rem;
            }

            .nav-clock {
                margin-top: 0.3rem;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation: none !important;
                transition: none !important;
            }
        }
    </style>
</head>
<body class="app-shell${isAuthPage ? ' auth-shell' : ''}">
<div id="pageProgress"></div>
<c:if test="${not isAuthPage}">
<nav class="navbar navbar-expand-lg shell-nav">
    <div class="container shell-nav-inner">
        <a class="navbar-brand shell-brand" href="${pageContext.request.contextPath}/home">EventSphere</a>
        <button class="navbar-toggler shell-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMain" aria-controls="navMain" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navMain">
            <ul class="navbar-nav ms-auto shell-links">
                <c:choose>
                    <c:when test="${not empty sessionScope.loggedUser}">
                        <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                        <c:if test="${sessionScope.loggedUser.role.name() == 'PARTICIPANT'}">
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/my-tickets">My Tickets</a></li>
                        </c:if>
                        <c:if test="${sessionScope.loggedUser.role.name() == 'ORGANIZER'}">
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/organizer/dashboard">Organizer</a></li>
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/organizer/stats">Stats</a></li>
                        </c:if>
                        <c:if test="${sessionScope.loggedUser.role.name() == 'ADMIN'}">
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin</a></li>
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/admin/events">Events</a></li>
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/admin/users">Users</a></li>
                            <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/admin/stats">Stats</a></li>
                        </c:if>
                        <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                        <c:if test="${sessionScope.loggedUser.role.name() == 'ORGANIZER' or sessionScope.loggedUser.role.name() == 'ADMIN'}">
                            <li class="nav-item ms-lg-2"><span id="navClock" class="nav-clock">--:--:--</span></li>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                        <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/login">Login</a></li>
                        <li class="nav-item"><a class="nav-link shell-link" href="${pageContext.request.contextPath}/register">Register</a></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
</c:if>
<main class="container py-4${isAuthPage ? ' auth-main' : ''}">
    <c:if test="${not isAuthPage and not empty pageTitle and pageTitle != 'Home'}">
        <nav class="app-breadcrumb-wrap" aria-label="breadcrumb">
            <ol class="breadcrumb app-breadcrumb">
                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="breadcrumb-item active" aria-current="page"><c:out value="${pageTitle}"/></li>
            </ol>
        </nav>
    </c:if>

    <c:if test="${not empty requestScope.success}">
        <div class="server-toast-data" data-type="success"><c:out value="${requestScope.success}"/></div>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="server-toast-data" data-type="error"><c:out value="${requestScope.error}"/></div>
    </c:if>
