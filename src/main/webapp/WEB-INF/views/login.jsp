<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Login"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .auth-page {
        min-height: 100vh;
        display: grid;
        grid-template-columns: 1fr 1fr;
    }

    .auth-form-column {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: clamp(1.25rem, 4vw, 3rem);
        background: #FFFFFF;
    }

    .auth-panel {
        width: min(460px, 100%);
        padding: clamp(1.25rem, 3vw, 2.1rem);
        border: 1px solid #E2E8F0;
        border-radius: 22px;
        box-shadow: 0 22px 44px rgba(45, 55, 72, 0.09);
    }

    .auth-sub {
        margin: 0;
        font-size: 0.78rem;
        letter-spacing: 0.1em;
        text-transform: uppercase;
        color: #718096;
        font-weight: 700;
    }

    .auth-title {
        margin: 0.35rem 0 0.2rem;
        font-size: clamp(2rem, 3vw, 2.6rem);
        color: #2D3748;
    }

    .auth-description {
        margin: 0 0 1.25rem;
        color: #4A5568;
    }

    .error-toast {
        margin-bottom: 1rem;
        padding: 0.7rem 0.9rem;
        border-radius: 12px;
        border: 1px solid #FECACA;
        background: #FFF5F5;
        color: #991B1B;
        font-size: 0.9rem;
    }

    .input-wrap {
        position: relative;
        margin-bottom: 1.05rem;
    }

    .input-wrap input {
        width: 100%;
        border: 0;
        border-bottom: 2px solid #CBD5E0;
        border-radius: 0;
        padding: 0.78rem 2.1rem 0.7rem 0;
        background: transparent;
        color: #1A202C;
    }

    .input-wrap input:focus {
        outline: none;
        border-bottom-color: #FF6B35;
        box-shadow: none;
    }

    .input-wrap label {
        position: absolute;
        left: 0;
        top: 0.84rem;
        color: #718096;
        pointer-events: none;
        transition: 0.2s ease;
    }

    .input-wrap input:focus + label,
    .input-wrap input:not(:placeholder-shown) + label {
        top: -0.2rem;
        font-size: 0.72rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: #FF6B35;
    }

    .toggle-eye {
        position: absolute;
        right: 0;
        top: 0.56rem;
        border: 0;
        background: transparent;
        color: #718096;
        padding: 0.25rem;
        font-size: 0.86rem;
    }

    .auth-submit {
        width: 100%;
        border: 0;
        border-radius: 999px;
        padding: 0.72rem 1rem;
        font-weight: 700;
        background: #FF6B35;
        color: #FFFFFF;
        box-shadow: 0 12px 22px rgba(255, 107, 53, 0.25);
        transition: transform 0.2s ease;
    }

    .auth-submit:hover {
        transform: scale(1.02);
        background: #F75A1E;
    }

    .auth-link {
        margin: 1rem 0 0;
        color: #4A5568;
    }

    .auth-link a {
        color: #FF6B35;
        font-weight: 700;
        text-decoration: none;
    }

    .auth-editorial {
        position: relative;
        overflow: hidden;
        padding: clamp(1.4rem, 5vw, 3.3rem);
        background: #FF6B35;
        color: #FFFFFF;
        display: flex;
        align-items: center;
    }

    .auth-editorial::before,
    .auth-editorial::after {
        content: "";
        position: absolute;
        border: 1px solid rgba(255, 255, 255, 0.26);
        transform: rotate(24deg);
    }

    .auth-editorial::before {
        width: 260px;
        height: 260px;
        top: -120px;
        right: -80px;
    }

    .auth-editorial::after {
        width: 320px;
        height: 320px;
        bottom: -170px;
        left: -120px;
    }

    .editorial-inner {
        position: relative;
        z-index: 1;
        width: min(520px, 100%);
    }

    .editorial-title {
        margin: 0;
        font-size: clamp(2.3rem, 5.6vw, 4.1rem);
        color: #FFFFFF;
        line-height: 0.95;
    }

    .editorial-tagline {
        margin: 0.85rem 0 1.5rem;
        font-size: 1rem;
        color: rgba(255, 255, 255, 0.92);
        max-width: 460px;
    }

    .feature-card {
        border: 1px solid rgba(255, 255, 255, 0.45);
        background: rgba(255, 255, 255, 0.2);
        backdrop-filter: blur(8px);
        border-radius: 14px;
        padding: 0.8rem 0.95rem;
        margin-bottom: 0.75rem;
    }

    .feature-card strong {
        display: block;
        font-family: "Playfair Display", serif;
        color: #FFFFFF;
        margin-bottom: 0.15rem;
    }

    .feature-card span {
        color: rgba(255, 255, 255, 0.92);
        font-size: 0.92rem;
    }

    .auth-foot {
        margin-top: 1.1rem;
        color: #718096;
        font-size: 0.8rem;
    }

    @media (max-width: 991.98px) {
        .auth-page {
            grid-template-columns: 1fr;
        }

        .auth-editorial {
            min-height: 280px;
            order: -1;
        }
    }
</style>

<section class="auth-page">
    <div class="auth-form-column">
        <div class="auth-panel">
            <c:if test="${not empty requestScope.error}">
                <div class="error-toast">
                    <strong>Login Error:</strong> <c:out value="${requestScope.error}"/>
                </div>
            </c:if>

            <p class="auth-sub">Secure Access</p>
            <h1 class="auth-title">Welcome Back</h1>
            <p class="auth-description">Sign in to continue your EventSphere journey.</p>

            <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="input-wrap">
                    <input type="email" id="loginEmail" name="email" value="${fn:escapeXml(param.email)}" placeholder=" " required>
                    <label for="loginEmail">Email Address</label>
                </div>

                <div class="input-wrap">
                    <input type="password" id="loginPassword" name="password" placeholder=" " required>
                    <label for="loginPassword">Password</label>
                    <button type="button" class="toggle-eye" data-toggle-target="loginPassword" aria-label="Toggle password visibility">Show</button>
                </div>

                <button type="submit" class="auth-submit">Sign In</button>
            </form>

            <p class="auth-link">
                Do not have an account?
                <a href="${pageContext.request.contextPath}/register">Register</a>
            </p>

            <jsp:useBean id="now" class="java.util.Date"/>
            <p class="auth-foot">Today: <fmt:formatDate value="${now}" pattern="yyyy-MM-dd"/></p>
        </div>
    </div>

    <div class="auth-editorial">
        <div class="editorial-inner">
            <h2 class="editorial-title">EventSphere</h2>
            <p class="editorial-tagline">Luxury ticketing for refined experiences. Discover, reserve, and manage memorable events with elegant simplicity.</p>

            <div class="feature-card">
                <strong>Curated Discoveries</strong>
                <span>Explore handpicked events across categories and cities.</span>
            </div>
            <div class="feature-card">
                <strong>Instant Booking</strong>
                <span>Purchase tickets quickly with secure checkout methods.</span>
            </div>
            <div class="feature-card">
                <strong>Smart Management</strong>
                <span>Track tickets, transfers, and event activity in one place.</span>
            </div>
        </div>
    </div>
</section>

<script>
    document.querySelectorAll("[data-toggle-target]").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const input = document.getElementById(btn.getAttribute("data-toggle-target"));
            if (!input) {
                return;
            }
            input.type = input.type === "password" ? "text" : "password";
            btn.textContent = input.type === "password" ? "Show" : "Hide";
        });
    });
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
