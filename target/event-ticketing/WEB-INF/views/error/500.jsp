<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Server Error"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .error-page {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
        min-height: 62vh;
        display: grid;
        place-items: center;
    }

    .error-page .error-shell {
        width: min(760px, 100%);
        text-align: center;
        border-radius: 1.35rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 30px 50px rgba(6, 7, 20, 0.42);
        padding: clamp(1.4rem, 4vw, 2.4rem);
        position: relative;
        overflow: hidden;
    }

    .error-page .error-shell::before,
    .error-page .error-shell::after {
        content: "";
        position: absolute;
        border-radius: 999px;
        filter: blur(5px);
        opacity: 0.75;
        pointer-events: none;
        animation: errorFloat 14s ease-in-out infinite;
    }

    .error-page .error-shell::before {
        width: 180px;
        height: 180px;
        left: -65px;
        top: -70px;
        background: radial-gradient(circle, rgba(124, 58, 237, 0.9), rgba(124, 58, 237, 0));
    }

    .error-page .error-shell::after {
        width: 210px;
        height: 210px;
        right: -80px;
        bottom: -90px;
        background: radial-gradient(circle, rgba(236, 72, 153, 0.9), rgba(236, 72, 153, 0));
        animation-delay: -5s;
    }

    .error-page .error-code {
        margin: 0;
        font-family: "Syne", sans-serif;
        font-size: clamp(3rem, 12vw, 6.1rem);
        line-height: 1;
        letter-spacing: 0.02em;
        background: linear-gradient(110deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .error-page .error-title {
        margin: 0.35rem 0 0.55rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.35rem, 3.8vw, 2rem);
        color: #F8F9FF;
    }

    .error-page .error-text {
        margin: 0 auto 1.15rem;
        max-width: 560px;
        color: rgba(219, 224, 250, 0.82);
    }

    .error-page .btn-vivid {
        border: 0;
        border-radius: 0.88rem;
        min-height: 44px;
        padding: 0.58rem 1rem;
        font-weight: 700;
        color: #FFFFFF;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 16px 30px rgba(124, 58, 237, 0.32);
        transition: transform 0.24s ease, box-shadow 0.24s ease;
    }

    .error-page .btn-vivid:hover {
        transform: translateY(-2px);
        box-shadow: 0 22px 35px rgba(236, 72, 153, 0.35);
        color: #FFFFFF;
    }

    @keyframes errorFloat {
        0%, 100% { transform: translateY(0) scale(1); }
        50% { transform: translateY(-14px) scale(1.06); }
    }
</style>

<section class="error-page">
    <div class="error-shell">
        <h1 class="error-code">500</h1>
        <h2 class="error-title">Server Error</h2>
        <p class="error-text">Something went wrong while processing your request.</p>
        <a class="btn-vivid" href="${pageContext.request.contextPath}/home">Back to Home</a>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
