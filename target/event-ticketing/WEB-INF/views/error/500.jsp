<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Server Error"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .error-page {
        min-height: 62vh;
        display: grid;
        place-items: center;
    }

    .error-shell {
        width: min(760px, 100%);
        text-align: center;
        border-radius: 22px;
        border: 1px solid #E2E8F0;
        background: #FFFFFF;
        box-shadow: 0 24px 44px rgba(45, 55, 72, 0.1);
        padding: clamp(1.3rem, 4vw, 2.3rem);
        position: relative;
        overflow: hidden;
    }

    .error-shell::before,
    .error-shell::after {
        content: "";
        position: absolute;
        border: 2px solid rgba(255, 107, 53, 0.18);
        transform: rotate(20deg);
        pointer-events: none;
    }

    .error-shell::before {
        width: 180px;
        height: 180px;
        top: -86px;
        left: -58px;
    }

    .error-shell::after {
        width: 210px;
        height: 210px;
        right: -86px;
        bottom: -100px;
    }

    .error-code {
        margin: 0;
        font-size: clamp(3rem, 11vw, 5.8rem);
        line-height: 1;
        color: #FF6B35;
    }

    .error-title {
        margin: 0.45rem 0 0.55rem;
        font-size: clamp(1.3rem, 3.8vw, 2rem);
        color: #2D3748;
    }

    .error-text {
        margin: 0 auto 1.15rem;
        max-width: 560px;
        color: #4A5568;
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
