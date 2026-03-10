<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Register"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    @import url("https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700;900&family=Syne:wght@700;800&display=swap");

    body > nav.navbar,
    body > footer.bg-dark.text-light.py-3.mt-5 {
        display: none !important;
    }

    main.container.py-4 {
        max-width: 100% !important;
        padding: 0 !important;
    }

    main.container.py-4 > .alert {
        display: none !important;
    }

    .auth-page {
        --bg: #0A0A0F;
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
        width: 100vw;
        margin-left: calc(50% - 50vw);
        margin-right: calc(50% - 50vw);
        min-height: 100vh;
        background: var(--bg);
        position: relative;
        overflow: hidden;
        display: flex;
        flex-direction: column;
        font-family: "DM Sans", sans-serif;
        color: #EAEAF7;
        isolation: isolate;
    }

    .auth-page * {
        position: relative;
        z-index: 2;
    }

    .auth-page::before {
        content: "";
        position: absolute;
        inset: 0;
        background:
                radial-gradient(circle at 15% 20%, rgba(124, 58, 237, 0.35), transparent 45%),
                radial-gradient(circle at 85% 12%, rgba(37, 99, 235, 0.28), transparent 42%),
                radial-gradient(circle at 75% 88%, rgba(236, 72, 153, 0.22), transparent 36%);
        z-index: 0;
    }

    .auth-page::after {
        content: "";
        position: absolute;
        inset: 0;
        z-index: 1;
        background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='180' height='180' viewBox='0 0 120 120'%3E%3Cg fill='%23ffffff' fill-opacity='0.035'%3E%3Ccircle cx='3' cy='3' r='1'/%3E%3Ccircle cx='33' cy='13' r='1'/%3E%3Ccircle cx='73' cy='23' r='1'/%3E%3Ccircle cx='103' cy='53' r='1'/%3E%3Ccircle cx='23' cy='83' r='1'/%3E%3Ccircle cx='93' cy='93' r='1'/%3E%3C/g%3E%3C/svg%3E");
        pointer-events: none;
        opacity: 0.8;
    }

    .auth-page .auth-grid {
        min-height: calc(100vh - 170px);
    }

    .auth-page .auth-visual {
        background: linear-gradient(145deg, rgba(124, 58, 237, 0.28), rgba(37, 99, 235, 0.18) 52%, rgba(236, 72, 153, 0.24));
        border-right: 1px solid rgba(255, 255, 255, 0.1);
        overflow: hidden;
        padding: 3rem 2.5rem;
        display: flex;
        align-items: center;
    }

    .auth-page .blob {
        position: absolute;
        border-radius: 999px;
        filter: blur(4px);
        opacity: 0.55;
        animation: floatBlob 20s ease-in-out infinite;
        z-index: 1;
    }

    .auth-page .blob.b1 {
        width: 280px;
        height: 280px;
        left: -70px;
        top: 10%;
        background: radial-gradient(circle, rgba(124, 58, 237, 0.9), rgba(124, 58, 237, 0));
    }

    .auth-page .blob.b2 {
        width: 240px;
        height: 240px;
        right: -80px;
        top: 28%;
        background: radial-gradient(circle, rgba(37, 99, 235, 0.88), rgba(37, 99, 235, 0));
        animation-delay: -6s;
    }

    .auth-page .blob.b3 {
        width: 260px;
        height: 260px;
        left: 22%;
        bottom: -90px;
        background: radial-gradient(circle, rgba(236, 72, 153, 0.9), rgba(236, 72, 153, 0));
        animation-delay: -10s;
    }

    .auth-page .visual-inner {
        max-width: 620px;
        margin: 0 auto;
    }

    .auth-page .visual-kicker {
        display: inline-block;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        font-size: 0.78rem;
        color: rgba(240, 242, 255, 0.78);
        margin-bottom: 1rem;
    }

    .auth-page .brand {
        font-family: "Syne", sans-serif;
        font-size: clamp(2rem, 4vw, 4.5rem);
        font-weight: 800;
        line-height: 1.02;
        margin-bottom: 0.75rem;
        background: linear-gradient(115deg, var(--p1) 0%, var(--p2) 44%, var(--p3) 100%);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        display: block;
        max-width: 100%;
        white-space: nowrap;
    }

    .auth-page .tagline {
        color: rgba(243, 244, 255, 0.85);
        font-size: 1.08rem;
        max-width: 420px;
        margin-bottom: 2rem;
    }

    .auth-page .feature-card {
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: rgba(255, 255, 255, 0.08);
        backdrop-filter: blur(20px);
        border-radius: 1rem;
        padding: 1rem 1.05rem;
        margin-bottom: 0.9rem;
        box-shadow: 0 16px 30px rgba(15, 15, 34, 0.3);
        transition: transform 0.35s ease, box-shadow 0.35s ease, border-color 0.35s ease;
    }

    .auth-page .feature-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 24px 36px rgba(124, 58, 237, 0.23);
        border-color: rgba(236, 72, 153, 0.5);
    }

    .auth-page .feature-icon {
        font-size: 1.35rem;
        margin-right: 0.65rem;
    }

    .auth-page .feature-title {
        font-weight: 700;
        color: #FBFCFF;
    }

    .auth-page .auth-form-wrap {
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 2.75rem 1.25rem;
    }

    .auth-page .auth-glass {
        width: min(560px, 100%);
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.24);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 28px 50px rgba(6, 6, 16, 0.45), 0 0 0 1px rgba(124, 58, 237, 0.12) inset;
        padding: 2rem 1.6rem;
    }

    .auth-page .auth-title {
        font-family: "Syne", sans-serif;
        font-weight: 800;
        letter-spacing: 0.01em;
        margin-bottom: 0.15rem;
    }

    .auth-page .auth-sub {
        text-transform: uppercase;
        letter-spacing: 0.1em;
        font-size: 0.74rem;
        color: rgba(233, 236, 255, 0.65);
        margin-bottom: 0.6rem;
    }

    .auth-page .accent-line {
        width: 92px;
        height: 4px;
        border-radius: 999px;
        background: linear-gradient(90deg, var(--p1), var(--p2), var(--p3));
        margin-bottom: 1.6rem;
    }

    .auth-page .input-wrap {
        position: relative;
        margin-bottom: 1rem;
    }

    .auth-page .input-wrap input {
        width: 100%;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: rgba(6, 8, 22, 0.65);
        color: #F5F6FF;
        padding: 1.15rem 3.1rem 0.7rem 0.9rem;
        outline: none;
        transition: border-color 0.28s ease, box-shadow 0.28s ease, background-color 0.28s ease;
    }

    .auth-page .input-wrap input:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 3px rgba(124, 58, 237, 0.22), 0 0 18px rgba(37, 99, 235, 0.24);
        background: rgba(7, 11, 28, 0.85);
    }

    .auth-page .input-wrap label {
        position: absolute;
        left: 0.9rem;
        top: 0.95rem;
        color: rgba(236, 238, 255, 0.63);
        font-size: 0.92rem;
        transition: all 0.22s ease;
        pointer-events: none;
    }

    .auth-page .input-wrap input:focus + label,
    .auth-page .input-wrap input:not(:placeholder-shown) + label {
        top: 0.42rem;
        font-size: 0.72rem;
        color: rgba(236, 72, 153, 0.95);
        letter-spacing: 0.03em;
    }

    .auth-page .toggle-eye {
        position: absolute;
        right: 0.75rem;
        top: 50%;
        transform: translateY(-50%);
        border: 0;
        background: transparent;
        color: rgba(230, 232, 255, 0.72);
        font-size: 1rem;
        padding: 0.25rem;
    }

    .auth-page .role-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 0.75rem;
        margin-bottom: 1rem;
    }

    .auth-page .role-choice input {
        position: absolute;
        opacity: 0;
        pointer-events: none;
    }

    .auth-page .role-card {
        display: block;
        cursor: pointer;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: rgba(255, 255, 255, 0.06);
        padding: 0.85rem 0.8rem;
        min-height: 130px;
        transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease;
    }

    .auth-page .role-card:hover {
        transform: translateY(-4px);
        border-color: rgba(236, 72, 153, 0.55);
        box-shadow: 0 16px 24px rgba(124, 58, 237, 0.2);
    }

    .auth-page .role-icon {
        display: inline-block;
        font-size: 1.35rem;
        margin-bottom: 0.4rem;
    }

    .auth-page .role-title {
        font-weight: 700;
        margin-bottom: 0.2rem;
        color: #FCFCFF;
    }

    .auth-page .role-desc {
        font-size: 0.78rem;
        color: rgba(229, 232, 250, 0.72);
        margin: 0;
        line-height: 1.35;
    }

    .auth-page .role-choice input:checked + .role-card {
        border-color: rgba(236, 72, 153, 0.95);
        box-shadow: 0 0 0 2px rgba(124, 58, 237, 0.38), 0 20px 32px rgba(37, 99, 235, 0.24);
        background: linear-gradient(135deg, rgba(124, 58, 237, 0.24), rgba(37, 99, 235, 0.2), rgba(236, 72, 153, 0.2));
    }

    .auth-page .btn-vivid {
        width: 100%;
        border: 0;
        border-radius: 0.95rem;
        color: #FFFFFF;
        font-weight: 700;
        letter-spacing: 0.02em;
        padding: 0.88rem 1rem;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 16px 24px rgba(124, 58, 237, 0.28);
        position: relative;
        overflow: hidden;
        transition: transform 0.26s ease, box-shadow 0.26s ease;
    }

    .auth-page .btn-vivid::before {
        content: "";
        position: absolute;
        top: -140%;
        left: -26%;
        width: 38%;
        height: 370%;
        transform: rotate(18deg);
        background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.45), transparent);
        transition: left 0.62s ease;
    }

    .auth-page .btn-vivid:hover {
        transform: scale(1.02);
        box-shadow: 0 24px 36px rgba(236, 72, 153, 0.32);
    }

    .auth-page .btn-vivid:hover::before {
        left: 114%;
    }

    .auth-page .auth-link {
        color: rgba(231, 233, 255, 0.8);
        margin-top: 1rem;
        text-align: center;
    }

    .auth-page .auth-link a {
        color: #E96DF7;
        font-weight: 700;
        text-decoration: none;
    }

    .auth-page .auth-link a:hover {
        color: #FFFFFF;
    }

    .auth-page .error-toast {
        position: fixed;
        top: 88px;
        right: 20px;
        z-index: 1080;
        border-radius: 0.9rem;
        border: 1px solid rgba(236, 72, 153, 0.75);
        background: linear-gradient(120deg, rgba(255, 32, 114, 0.92), rgba(168, 20, 100, 0.92));
        color: #FFF5FC;
        padding: 0.85rem 1rem;
        box-shadow: 0 18px 36px rgba(95, 12, 55, 0.45);
        max-width: 380px;
        animation: revealUp 0.55s ease both, shake 0.45s ease 0.55s;
    }

    .auth-page .auth-top-nav {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        z-index: 6;
        background: transparent;
        border: 0;
    }

    .auth-page .auth-top-nav .nav-inner {
        width: min(1240px, calc(100% - 2rem));
        margin: 0 auto;
        padding: 1.15rem 0;
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .auth-page .nav-brand {
        font-family: "Syne", sans-serif;
        font-size: 1.55rem;
        font-weight: 800;
        text-decoration: none;
        background: linear-gradient(115deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        letter-spacing: 0.01em;
    }

    .auth-page .nav-links {
        display: flex;
        gap: 1.15rem;
        align-items: center;
    }

    .auth-page .nav-links a {
        color: #F3F4FF;
        text-decoration: none;
        font-weight: 500;
        position: relative;
        padding-bottom: 0.22rem;
    }

    .auth-page .nav-links a::after {
        content: "";
        position: absolute;
        left: 0;
        bottom: -1px;
        width: 0;
        height: 2px;
        border-radius: 999px;
        background: linear-gradient(90deg, var(--p1), var(--p3));
        transition: width 0.3s ease;
    }

    .auth-page .nav-links a:hover::after,
    .auth-page .nav-links a.active::after {
        width: 100%;
    }

    .auth-page .auth-content {
        padding-top: 80px;
        flex: 1;
    }

    .auth-page .auth-footer {
        margin-top: auto;
        text-align: center;
        padding: 1rem 1rem 1.35rem;
        border-top: 1px solid transparent;
        border-image: linear-gradient(90deg, rgba(124, 58, 237, 0.85), rgba(236, 72, 153, 0.85)) 1;
        background: rgba(10, 10, 15, 0.88);
    }

    .auth-page .auth-footer .copyright {
        font-size: 0.92rem;
        margin-bottom: 0.15rem;
        color: rgba(237, 239, 255, 0.84);
    }

    .auth-page .auth-footer .copyright .accent {
        background: linear-gradient(115deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
        font-weight: 700;
    }

    .auth-page .auth-footer .subtext {
        font-size: 0.75rem;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: rgba(214, 218, 246, 0.56);
    }

    .auth-page .reveal {
        opacity: 0;
        transform: translateY(22px);
        animation: revealUp 0.8s cubic-bezier(.21,.8,.28,1) forwards;
        animation-delay: var(--d, 0s);
    }

    @keyframes revealUp {
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes floatBlob {
        0%, 100% {
            transform: translateY(0) translateX(0) scale(1);
        }
        50% {
            transform: translateY(-26px) translateX(16px) scale(1.08);
        }
    }

    @keyframes shake {
        0%, 100% {
            transform: translateX(0);
        }
        20% {
            transform: translateX(-8px);
        }
        40% {
            transform: translateX(8px);
        }
        60% {
            transform: translateX(-6px);
        }
        80% {
            transform: translateX(6px);
        }
    }

    @media (max-width: 991.98px) {
        .auth-page .auth-grid {
            min-height: auto;
        }

        .auth-page .auth-visual {
            border-right: 0;
            border-bottom: 1px solid rgba(255, 255, 255, 0.13);
            padding: 2.2rem 1.2rem 1.8rem;
        }

        .auth-page .auth-form-wrap {
            padding: 1.6rem 1rem 2rem;
        }

        .auth-page .auth-top-nav .nav-inner {
            width: calc(100% - 1.4rem);
        }

        .auth-page .nav-brand {
            font-size: 1.28rem;
        }

        .auth-page .nav-links {
            gap: 0.8rem;
            font-size: 0.92rem;
        }

        .auth-page .error-toast {
            left: 12px;
            right: 12px;
            max-width: none;
            top: 80px;
        }

        .auth-page .brand {
            white-space: nowrap;
        }
    }

    @media (max-width: 575.98px) {
        .auth-page .role-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<section class="auth-page">
    <nav class="auth-top-nav">
        <div class="nav-inner">
            <a class="nav-brand" href="${pageContext.request.contextPath}/home">EventSphere</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/home">Home</a>
                <a href="${pageContext.request.contextPath}/login">Login</a>
                <a class="active" href="${pageContext.request.contextPath}/register">Register</a>
            </div>
        </div>
    </nav>

    <c:if test="${not empty requestScope.error}">
        <div class="error-toast" id="serverErrorToast">
            <strong>Registration Error:</strong> <c:out value="${requestScope.error}"/>
        </div>
    </c:if>
    <div class="error-toast" id="clientErrorToast" style="display: none;"></div>

    <div class="container-fluid auth-content">
        <div class="row g-0 auth-grid">
            <div class="col-lg-6 auth-visual">
                <div class="blob b1"></div>
                <div class="blob b2"></div>
                <div class="blob b3"></div>

                <div class="visual-inner">
                    <p class="visual-kicker reveal" style="--d: .05s;">Immersive Ticketing Platform</p>
                    <h1 class="brand reveal" style="--d: .13s;">EventSphere</h1>
                    <p class="tagline reveal" style="--d: .2s;">Your events. Your world.</p>

                    <div class="feature-card reveal" style="--d: .28s;">
                        <span class="feature-icon">🎫</span>
                        <span class="feature-title">Buy Tickets Instantly</span>
                    </div>
                    <div class="feature-card reveal" style="--d: .36s;">
                        <span class="feature-icon">🎪</span>
                        <span class="feature-title">Discover Amazing Events</span>
                    </div>
                    <div class="feature-card reveal" style="--d: .44s;">
                        <span class="feature-icon">📊</span>
                        <span class="feature-title">Manage Everything</span>
                    </div>
                </div>
            </div>

            <div class="col-lg-6 auth-form-wrap">
                <div class="auth-glass reveal" style="--d: .2s;">
                    <p class="auth-sub">Create Account</p>
                    <h2 class="auth-title">Join EventSphere</h2>
                    <div class="accent-line"></div>

                    <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="registerForm">
                        <input type="hidden" name="csrfToken" value="${csrfToken}">

                        <div class="input-wrap reveal" style="--d: .28s;">
                            <input type="text" id="fullName" name="name" minlength="2" maxlength="120" value="${fn:escapeXml(param.name)}" placeholder=" " required>
                            <label for="fullName">Full Name</label>
                        </div>

                        <div class="input-wrap reveal" style="--d: .34s;">
                            <input type="email" id="registerEmail" name="email" value="${fn:escapeXml(param.email)}" placeholder=" " required>
                            <label for="registerEmail">Email Address</label>
                        </div>

                        <div class="input-wrap reveal" style="--d: .4s;">
                            <input type="password" id="registerPassword" name="password" minlength="8" placeholder=" " required>
                            <label for="registerPassword">Password</label>
                            <button type="button" class="toggle-eye" data-toggle-target="registerPassword" aria-label="Toggle password visibility">👁</button>
                        </div>

                        <div class="input-wrap reveal" style="--d: .46s;">
                            <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" placeholder=" " required>
                            <label for="confirmPassword">Confirm Password</label>
                            <button type="button" class="toggle-eye" data-toggle-target="confirmPassword" aria-label="Toggle password visibility">👁</button>
                        </div>

                        <div class="role-grid reveal" style="--d: .52s;">
                            <div class="role-choice">
                                <input type="radio" id="roleParticipant" name="role" value="PARTICIPANT"
                                       <c:if test="${empty param.role or param.role == 'PARTICIPANT'}">checked</c:if>>
                                <label class="role-card" for="roleParticipant">
                                    <span class="role-icon">🎟️</span>
                                    <div class="role-title">Participant</div>
                                    <p class="role-desc">Discover and book unforgettable events in seconds.</p>
                                </label>
                            </div>
                            <div class="role-choice">
                                <input type="radio" id="roleOrganizer" name="role" value="ORGANIZER"
                                       <c:if test="${param.role == 'ORGANIZER'}">checked</c:if>>
                                <label class="role-card" for="roleOrganizer">
                                    <span class="role-icon">🎪</span>
                                    <div class="role-title">Organizer</div>
                                    <p class="role-desc">Launch and manage events with rich analytics tools.</p>
                                </label>
                            </div>
                        </div>

                        <button type="submit" class="btn-vivid reveal" style="--d: .58s;">Create Account</button>
                    </form>

                    <p class="auth-link reveal" style="--d: .64s;">
                        Already have an account?
                        <a href="${pageContext.request.contextPath}/login">Login</a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <footer class="auth-footer">
        <div class="copyright">&copy; 2026 <span class="accent">EventSphere</span> — All rights reserved</div>
        <div class="subtext">Powered by Jakarta EE 10</div>
    </footer>
</section>

<script>
    document.querySelectorAll("[data-toggle-target]").forEach(function (btn) {
        btn.addEventListener("click", function () {
            const input = document.getElementById(btn.getAttribute("data-toggle-target"));
            if (!input) {
                return;
            }
            input.type = input.type === "password" ? "text" : "password";
            btn.textContent = input.type === "password" ? "👁" : "🙈";
        });
    });

    (function () {
        const form = document.getElementById("registerForm");
        const password = document.getElementById("registerPassword");
        const confirmPassword = document.getElementById("confirmPassword");
        const clientToast = document.getElementById("clientErrorToast");

        if (!form || !password || !confirmPassword || !clientToast) {
            return;
        }

        form.addEventListener("submit", function (event) {
            if (password.value !== confirmPassword.value) {
                event.preventDefault();
                clientToast.innerHTML = "<strong>Validation Error:</strong> Passwords do not match.";
                clientToast.style.display = "block";
                clientToast.style.animation = "none";
                void clientToast.offsetWidth;
                clientToast.style.animation = "revealUp 0.55s ease both, shake 0.45s ease 0.55s";
                confirmPassword.focus();
            }
        });
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
