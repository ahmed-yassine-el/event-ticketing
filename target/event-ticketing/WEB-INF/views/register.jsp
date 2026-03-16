<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Register"/>
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
        padding: clamp(1.15rem, 4vw, 2.8rem);
        background: #FFFFFF;
    }

    .auth-panel {
        width: min(500px, 100%);
        padding: clamp(1.2rem, 3vw, 2rem);
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
        margin: 0.3rem 0 0.2rem;
        font-size: clamp(2rem, 3vw, 2.45rem);
        color: #2D3748;
    }

    .auth-description {
        margin: 0 0 1rem;
        color: #4A5568;
    }

    .error-toast {
        margin-bottom: 0.85rem;
        padding: 0.7rem 0.9rem;
        border-radius: 12px;
        border: 1px solid #FECACA;
        background: #FFF5F5;
        color: #991B1B;
        font-size: 0.9rem;
    }

    .input-wrap {
        position: relative;
        margin-bottom: 1rem;
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

    .role-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 0.7rem;
        margin-bottom: 1rem;
    }

    .role-choice input {
        position: absolute;
        opacity: 0;
        pointer-events: none;
    }

    .role-card {
        display: block;
        border: 1px solid #E2E8F0;
        border-radius: 14px;
        padding: 0.7rem 0.8rem;
        cursor: pointer;
        background: #FFFFFF;
        transition: 0.2s ease;
    }

    .role-title {
        font-family: "Playfair Display", serif;
        color: #2D3748;
        font-size: 1.05rem;
        margin-bottom: 0.2rem;
    }

    .role-desc {
        margin: 0;
        font-size: 0.82rem;
        color: #64748B;
    }

    .role-choice input:checked + .role-card {
        border-color: #FF6B35;
        background: #FFF4EE;
        box-shadow: 0 10px 16px rgba(255, 107, 53, 0.15);
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
        font-size: clamp(2.2rem, 5.6vw, 4rem);
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

    @keyframes revealUp {
        from {
            opacity: 0;
            transform: translateY(8px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @keyframes shake {
        20%, 60% { transform: translateX(-4px); }
        40%, 80% { transform: translateX(4px); }
        100% { transform: translateX(0); }
    }

    @media (max-width: 991.98px) {
        .auth-page {
            grid-template-columns: 1fr;
        }

        .auth-editorial {
            min-height: 280px;
            order: -1;
        }

        .role-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<section class="auth-page">
    <div class="auth-form-column">
        <div class="auth-panel">
            <c:if test="${not empty requestScope.error}">
                <div class="error-toast" id="serverErrorToast">
                    <strong>Registration Error:</strong> <c:out value="${requestScope.error}"/>
                </div>
            </c:if>
            <div class="error-toast" id="clientErrorToast" style="display: none;"></div>

            <p class="auth-sub">Create Account</p>
            <h1 class="auth-title">Join EventSphere</h1>
            <p class="auth-description">Start booking, organizing, and managing extraordinary events.</p>

            <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="registerForm">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div class="input-wrap">
                    <input type="text" id="fullName" name="name" minlength="2" maxlength="120" value="${fn:escapeXml(param.name)}" placeholder=" " required>
                    <label for="fullName">Full Name</label>
                </div>

                <div class="input-wrap">
                    <input type="email" id="registerEmail" name="email" value="${fn:escapeXml(param.email)}" placeholder=" " required>
                    <label for="registerEmail">Email Address</label>
                </div>

                <div class="input-wrap">
                    <input type="password" id="registerPassword" name="password" minlength="8" placeholder=" " required>
                    <label for="registerPassword">Password</label>
                    <button type="button" class="toggle-eye" data-toggle-target="registerPassword" aria-label="Toggle password visibility">Show</button>
                </div>

                <div class="input-wrap">
                    <input type="password" id="confirmPassword" name="confirmPassword" minlength="8" placeholder=" " required>
                    <label for="confirmPassword">Confirm Password</label>
                    <button type="button" class="toggle-eye" data-toggle-target="confirmPassword" aria-label="Toggle password visibility">Show</button>
                </div>

                <div class="role-grid">
                    <div class="role-choice">
                        <input type="radio" id="roleParticipant" name="role" value="PARTICIPANT"
                               <c:if test="${empty param.role or param.role == 'PARTICIPANT'}">checked</c:if>>
                        <label class="role-card" for="roleParticipant">
                            <div class="role-title">Participant</div>
                            <p class="role-desc">Browse and reserve tickets for the events you love.</p>
                        </label>
                    </div>
                    <div class="role-choice">
                        <input type="radio" id="roleOrganizer" name="role" value="ORGANIZER"
                               <c:if test="${param.role == 'ORGANIZER'}">checked</c:if>>
                        <label class="role-card" for="roleOrganizer">
                            <div class="role-title">Organizer</div>
                            <p class="role-desc">Publish events and monitor performance in real time.</p>
                        </label>
                    </div>
                </div>

                <button type="submit" class="auth-submit">Create Account</button>
            </form>

            <p class="auth-link">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Login</a>
            </p>
        </div>
    </div>

    <div class="auth-editorial">
        <div class="editorial-inner">
            <h2 class="editorial-title">EventSphere</h2>
            <p class="editorial-tagline">A refined digital stage for audiences and organizers to meet beautifully curated moments.</p>

            <div class="feature-card">
                <strong>Elegant Discovery</strong>
                <span>Find premium events by category, city, and date in seconds.</span>
            </div>
            <div class="feature-card">
                <strong>Seamless Access</strong>
                <span>Enjoy secure account setup with instant ticket-ready access.</span>
            </div>
            <div class="feature-card">
                <strong>Growth Ready</strong>
                <span>Scale from your first event to full portfolio analytics.</span>
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
                clientToast.style.animation = "revealUp 0.4s ease both, shake 0.4s ease 0.4s";
                confirmPassword.focus();
            }
        });
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
