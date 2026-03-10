<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><c:out value="${empty pageTitle ? 'Event Ticketing' : pageTitle}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/app.css" rel="stylesheet">
    <style>
        @import url("https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700;900&family=Syne:wght@700;800&display=swap");

        :root {
            --bg-main: #0A0A0F;
            --surface-1: rgba(255, 255, 255, 0.08);
            --surface-2: rgba(255, 255, 255, 0.12);
            --text-main: #ECECFA;
            --text-dim: #B7B8CC;
            --grad-a: #7C3AED;
            --grad-b: #2563EB;
            --grad-c: #EC4899;
            --border-soft: rgba(255, 255, 255, 0.2);
        }

        html {
            scroll-behavior: smooth;
        }

        *, *::before, *::after {
            box-sizing: border-box;
        }

        body.app-shell {
            margin: 0;
            min-height: 100vh;
            background: var(--bg-main);
            color: var(--text-main);
            font-family: "DM Sans", sans-serif;
            position: relative;
            overflow-x: hidden;
        }

        body.app-shell::before {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: -2;
            background:
                    radial-gradient(circle at 8% 16%, rgba(124, 58, 237, 0.32), transparent 40%),
                    radial-gradient(circle at 88% 22%, rgba(37, 99, 235, 0.3), transparent 42%),
                    radial-gradient(circle at 70% 86%, rgba(236, 72, 153, 0.25), transparent 38%),
                    linear-gradient(180deg, rgba(10, 10, 15, 0.96), rgba(10, 10, 15, 1));
        }

        body.app-shell::after {
            content: "";
            position: fixed;
            inset: 0;
            pointer-events: none;
            z-index: -1;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='220' height='220' viewBox='0 0 120 120'%3E%3Cg fill='%23ffffff' fill-opacity='0.03'%3E%3Ccircle cx='12' cy='11' r='1.2'/%3E%3Ccircle cx='56' cy='18' r='1.1'/%3E%3Ccircle cx='93' cy='41' r='1.1'/%3E%3Ccircle cx='33' cy='71' r='1.1'/%3E%3Ccircle cx='86' cy='98' r='1.2'/%3E%3C/g%3E%3C/svg%3E");
            animation: grainShift 28s linear infinite;
            opacity: 0.55;
        }

        @keyframes grainShift {
            0% { transform: translate(0, 0); }
            50% { transform: translate(-16px, 12px); }
            100% { transform: translate(0, 0); }
        }

        #pageProgress {
            position: fixed;
            top: 0;
            left: 0;
            height: 3px;
            width: 0;
            z-index: 2000;
            background: linear-gradient(90deg, var(--grad-a), var(--grad-b), var(--grad-c));
            box-shadow: 0 0 16px rgba(124, 58, 237, 0.7);
            transition: width 0.35s ease;
        }

        .shell-nav.navbar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 1030;
            background: transparent !important;
            border-bottom: 0;
            backdrop-filter: none;
        }

        .shell-nav-inner {
            max-width: min(1240px, calc(100% - 1.75rem));
        }

        .shell-brand {
            font-family: "Syne", sans-serif;
            font-size: 1.52rem;
            font-weight: 800;
            text-decoration: none;
            letter-spacing: 0.01em;
            background: linear-gradient(110deg, var(--grad-a), var(--grad-b), var(--grad-c));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .shell-toggler {
            border-color: rgba(255, 255, 255, 0.35) !important;
            box-shadow: none !important;
        }

        .shell-links {
            gap: 0.35rem;
            align-items: center;
        }

        .shell-link.nav-link {
            color: rgba(237, 239, 255, 0.84) !important;
            font-weight: 500;
            border-radius: 999px;
            padding: 0.45rem 0.88rem !important;
            position: relative;
            transition: color 0.25s ease, transform 0.25s ease;
        }

        .shell-link.nav-link::after {
            content: "";
            position: absolute;
            left: 0.78rem;
            right: 0.78rem;
            bottom: 0.22rem;
            height: 2px;
            border-radius: 999px;
            background: linear-gradient(90deg, var(--grad-a), var(--grad-c));
            transform: scaleX(0);
            transform-origin: left center;
            transition: transform 0.25s ease;
        }

        .shell-link.nav-link:hover,
        .shell-link.nav-link:focus,
        .shell-link.nav-link.active-route {
            color: #FFFFFF !important;
            transform: translateY(-1px);
        }

        .shell-link.nav-link:hover::after,
        .shell-link.nav-link:focus::after,
        .shell-link.nav-link.active-route::after {
            transform: scaleX(1);
        }

        .nav-clock {
            border-radius: 0.8rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            background: rgba(255, 255, 255, 0.08);
            color: rgba(240, 242, 255, 0.9);
            font-size: 0.8rem;
            letter-spacing: 0.06em;
            min-width: 118px;
            text-align: center;
            padding: 0.35rem 0.6rem;
            font-variant-numeric: tabular-nums;
        }

        main.container.py-4 {
            position: relative;
            z-index: 1;
            width: calc(100% - 1.75rem);
            max-width: 1200px !important;
            margin: 0 auto;
            padding-top: 80px !important;
            padding-bottom: 2.2rem !important;
        }

        .app-breadcrumb-wrap {
            margin-bottom: 1rem;
        }

        .app-breadcrumb {
            margin: 0;
            padding: 0.48rem 0.7rem;
            border-radius: 0.85rem;
            border: 1px solid rgba(255, 255, 255, 0.18);
            background: linear-gradient(130deg, rgba(255, 255, 255, 0.09), rgba(255, 255, 255, 0.03));
            backdrop-filter: blur(20px);
        }

        .app-breadcrumb .breadcrumb-item,
        .app-breadcrumb .breadcrumb-item a {
            color: rgba(221, 226, 250, 0.8);
            text-decoration: none;
            font-size: 0.84rem;
        }

        .app-breadcrumb .breadcrumb-item.active {
            color: #F8F9FF;
            font-weight: 700;
        }

        .app-breadcrumb .breadcrumb-item + .breadcrumb-item::before {
            color: rgba(216, 221, 247, 0.58);
        }

        .server-toast-data {
            display: none;
        }

        .table {
            --bs-table-border-color: rgba(255, 255, 255, 0.08);
        }

        .table tbody tr td {
            transition: background-color 0.24s ease, border-left-color 0.24s ease;
        }

        .table tbody tr:nth-child(odd) td {
            background: linear-gradient(90deg, rgba(255, 255, 255, 0.02), rgba(255, 255, 255, 0));
        }

        .table tbody tr:hover td {
            background: linear-gradient(90deg, rgba(124, 58, 237, 0.15), rgba(37, 99, 235, 0.1), rgba(236, 72, 153, 0.08));
        }

        .table tbody tr:hover td:first-child {
            border-left: 4px solid transparent;
            border-image: linear-gradient(180deg, var(--grad-a), var(--grad-c)) 1;
        }

        .table-export-wrap {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 0.55rem;
        }

        .table-export-btn {
            border-radius: 0.75rem;
            border: 1px solid rgba(124, 58, 237, 0.62);
            background: rgba(124, 58, 237, 0.2);
            color: #F0E4FF;
            font-weight: 700;
            font-size: 0.78rem;
            padding: 0.36rem 0.74rem;
        }

        .table-export-btn:hover {
            background: rgba(124, 58, 237, 0.32);
            color: #FFFFFF;
        }

        .ripple-host {
            position: relative;
            overflow: hidden;
        }

        .ripple-splash {
            position: absolute;
            border-radius: 50%;
            transform: scale(0);
            animation: rippleBurst 0.65s ease-out;
            background: rgba(255, 255, 255, 0.35);
            pointer-events: none;
        }

        @keyframes rippleBurst {
            to {
                transform: scale(3.4);
                opacity: 0;
            }
        }

        .tilt-card {
            transform-style: preserve-3d;
            transition: transform 0.22s ease, box-shadow 0.22s ease;
            will-change: transform;
        }

        .kpi-card {
            position: relative;
            overflow: hidden;
        }

        .kpi-card::before {
            content: "";
            position: absolute;
            inset: -90%;
            background: conic-gradient(from 0deg, rgba(124, 58, 237, 0.9), rgba(37, 99, 235, 0.85), rgba(236, 72, 153, 0.9), rgba(124, 58, 237, 0.9));
            animation: spinBorder 5.2s linear infinite;
            opacity: 0.4;
            z-index: 0;
        }

        .kpi-card::after {
            content: "";
            position: absolute;
            inset: 1px;
            border-radius: inherit;
            background: rgba(11, 12, 23, 0.62);
            z-index: 0;
        }

        .kpi-card > * {
            position: relative;
            z-index: 1;
        }

        .kpi-sparkline {
            width: 100%;
            height: 42px;
            margin-top: 0.5rem;
            opacity: 0.85;
        }

        @keyframes spinBorder {
            to { transform: rotate(360deg); }
        }

        .field-validation-mark {
            position: absolute;
            right: 0.66rem;
            top: 50%;
            transform: translateY(-50%);
            width: 18px;
            height: 18px;
            border-radius: 999px;
            border: 1px solid rgba(255, 255, 255, 0.32);
            background: rgba(255, 255, 255, 0.08);
            color: transparent;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.66rem;
            font-weight: 700;
            pointer-events: none;
        }

        textarea + .field-validation-mark {
            top: 1rem;
            transform: none;
        }

        .field-validation-mark.is-valid {
            background: rgba(34, 197, 94, 0.2);
            border-color: rgba(34, 197, 94, 0.6);
            color: #D8FFE5;
        }

        .field-validation-mark.is-valid::before {
            content: "v";
        }

        .field-validation-mark.is-invalid {
            display: none;
        }

        input::-ms-clear,
        input::-ms-reveal {
            display: none;
        }

        .form-control:invalid,
        .form-control.is-invalid,
        .form-select:invalid,
        .form-select.is-invalid,
        .was-validated .form-control:invalid,
        .was-validated .form-select:invalid {
            background-image: none !important;
            padding-right: 0.75rem !important;
        }

        .empty-state-inline {
            text-align: center;
            padding: 1.2rem 0.8rem;
            color: rgba(219, 224, 250, 0.82);
        }

        .empty-state-inline .icon {
            display: inline-block;
            margin-bottom: 0.35rem;
            font-size: 1.45rem;
            background: linear-gradient(110deg, var(--grad-a), var(--grad-b), var(--grad-c));
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        @media (max-width: 991.98px) {
            .shell-nav-inner,
            main.container.py-4 {
                width: calc(100% - 1.2rem);
            }

            .shell-brand {
                font-size: 1.32rem;
            }

            #navMain {
                position: fixed;
                top: 0;
                right: 0;
                width: min(310px, 84vw);
                height: 100vh;
                background: rgba(10, 10, 15, 0.96);
                border-left: 1px solid rgba(255, 255, 255, 0.12);
                padding: 5.2rem 1rem 1rem;
                transform: translateX(100%);
                opacity: 0;
                visibility: hidden;
                transition: transform 0.32s ease, opacity 0.32s ease;
                backdrop-filter: blur(20px);
                overflow-y: auto;
                z-index: 1040;
            }

            #navMain.show {
                transform: translateX(0);
                opacity: 1;
                visibility: visible;
            }

            .shell-links {
                margin-top: 0;
                border-top: 0;
                gap: 0.25rem;
            }

            .shell-link.nav-link {
                border-radius: 0.76rem;
            }

            .nav-clock {
                margin-top: 0.55rem;
                width: 100%;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation: none !important;
                transition: none !important;
            }

            html {
                scroll-behavior: auto;
            }
        }
    </style>
</head>
<body class="app-shell">
<div id="pageProgress"></div>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shell-nav">
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
<main class="container py-4">
    <c:if test="${not empty pageTitle and pageTitle != 'Home' and pageTitle != 'Login' and pageTitle != 'Register'}">
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
