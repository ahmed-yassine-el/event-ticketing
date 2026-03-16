<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
</main>

<c:if test="${pageTitle != 'Login' and pageTitle != 'Register'}">
<footer class="shell-footer py-3">
    <div class="container shell-footer-inner">
        <p class="shell-copy">&copy; 2026 <strong>EventSphere</strong></p>
        <p class="shell-stack">Jakarta EE 10 Ticketing Platform</p>
    </div>
</footer>
</c:if>

<button id="backToTop" type="button" aria-label="Back to top">Top</button>
<div id="globalToastStack" class="app-toast-stack" aria-live="polite" aria-atomic="true"></div>

<div class="modal fade app-confirm-modal" id="confirmActionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirm action</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="confirmActionText">Are you sure you want to continue?</div>
            <div class="modal-footer">
                <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn-modal-danger" id="confirmActionBtn">Continue</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    (function () {
        const doc = document;
        const win = window;

        const pageProgress = doc.getElementById("pageProgress");
        if (pageProgress) {
            pageProgress.style.width = "30%";
            win.addEventListener("load", function () {
                pageProgress.style.width = "100%";
                setTimeout(function () {
                    pageProgress.style.opacity = "0";
                }, 500);
            });
        }

        doc.querySelectorAll(".shell-link").forEach(function (link) {
            try {
                const currentPath = win.location.pathname.replace(/\/+$/, "");
                const targetPath = new URL(link.href, win.location.origin).pathname.replace(/\/+$/, "");
                const isHome = /\/home$/.test(targetPath);
                const active = currentPath === targetPath || (!isHome && currentPath.indexOf(targetPath + "/") === 0);
                if (active) {
                    link.classList.add("active-route");
                }
            } catch (error) {
            }
        });

        const navClock = doc.getElementById("navClock");
        if (navClock) {
            const tick = function () {
                navClock.textContent = new Date().toLocaleTimeString([], { hour12: false });
            };
            tick();
            setInterval(tick, 1000);
        }

        const toastStack = doc.getElementById("globalToastStack");
        const pushToast = function (text, type) {
            if (!toastStack || !text) {
                return;
            }
            const toast = doc.createElement("div");
            toast.className = "app-toast " + (type || "info");
            toast.textContent = text;
            toastStack.appendChild(toast);
            setTimeout(function () {
                toast.classList.add("out");
                setTimeout(function () {
                    toast.remove();
                }, 260);
            }, 3000);
        };

        doc.querySelectorAll(".server-toast-data").forEach(function (node) {
            const text = (node.textContent || "").trim();
            if (!text) {
                return;
            }
            pushToast(text, node.getAttribute("data-type") || "info");
        });

        const confirmModalEl = doc.getElementById("confirmActionModal");
        const confirmText = doc.getElementById("confirmActionText");
        const confirmBtn = doc.getElementById("confirmActionBtn");
        const confirmModal = confirmModalEl && win.bootstrap ? new bootstrap.Modal(confirmModalEl) : null;
        let pendingForm = null;

        doc.addEventListener("submit", function (event) {
            if (!confirmModal || !event.target || event.target.tagName !== "FORM") {
                return;
            }
            const form = event.target;
            if (form.dataset.confirmed === "1") {
                form.dataset.confirmed = "0";
                return;
            }
            const action = (form.getAttribute("action") || "").toLowerCase();
            const submitEl = form.querySelector("button[type='submit'], input[type='submit']");
            const label = submitEl ? ((submitEl.textContent || submitEl.value || "").toLowerCase()) : "";
            if (!/(delete|cancel)/.test(action + " " + label)) {
                return;
            }
            event.preventDefault();
            pendingForm = form;
            if (confirmText) {
                confirmText.textContent = /(cancel)/.test(action + " " + label)
                    ? "This will cancel the selected item. Continue?"
                    : "This action cannot be undone. Continue?";
            }
            confirmModal.show();
        });

        if (confirmBtn) {
            confirmBtn.addEventListener("click", function () {
                if (!pendingForm) {
                    return;
                }
                pendingForm.dataset.confirmed = "1";
                pendingForm.submit();
                pendingForm = null;
                if (confirmModal) {
                    confirmModal.hide();
                }
            });
        }

        if (confirmModalEl) {
            confirmModalEl.addEventListener("hidden.bs.modal", function () {
                pendingForm = null;
            });
        }

        const backToTop = doc.getElementById("backToTop");
        const updateBackToTop = function () {
            if (!backToTop) {
                return;
            }
            backToTop.classList.toggle("show", (win.pageYOffset || doc.documentElement.scrollTop) > 260);
        };

        if (backToTop) {
            backToTop.addEventListener("click", function () {
                win.scrollTo({ top: 0, behavior: "smooth" });
            });
            updateBackToTop();
            win.addEventListener("scroll", updateBackToTop, { passive: true });
        }
    })();
</script>
<script src="${pageContext.request.contextPath}/resources/js/app.js"></script>
</body>
</html>
