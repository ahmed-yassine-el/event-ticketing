<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>
<style>
    .shell-footer.bg-dark.text-light.py-3.mt-5 {
        margin-top: 3rem !important;
        position: relative;
        z-index: 1;
        background: rgba(10, 10, 15, 0.88) !important;
        border-top: 1px solid transparent;
        border-image: linear-gradient(90deg, rgba(124, 58, 237, 0.9), rgba(37, 99, 235, 0.85), rgba(236, 72, 153, 0.9)) 1;
        backdrop-filter: blur(20px);
        box-shadow: 0 -18px 36px rgba(6, 6, 16, 0.28);
    }

    .shell-footer-inner {
        width: min(1240px, calc(100% - 1.75rem));
        max-width: none;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 0.8rem;
    }

    .shell-copy,
    .shell-stack {
        margin: 0;
        color: rgba(231, 233, 249, 0.8);
        font-size: 0.9rem;
    }

    .shell-copy strong {
        font-family: "Syne", sans-serif;
        font-weight: 700;
        letter-spacing: 0.01em;
        background: linear-gradient(110deg, #7C3AED, #2563EB, #EC4899);
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .shell-stack {
        text-transform: uppercase;
        letter-spacing: 0.08em;
        font-size: 0.74rem;
        color: rgba(193, 197, 230, 0.68);
    }

    #backToTop {
        position: fixed;
        right: 1rem;
        bottom: 1.1rem;
        z-index: 1200;
        border: 0;
        border-radius: 0.85rem;
        min-height: 40px;
        padding: 0.4rem 0.75rem;
        color: #FFFFFF;
        font-weight: 700;
        background: linear-gradient(100deg, #7C3AED, #2563EB, #EC4899);
        box-shadow: 0 16px 30px rgba(124, 58, 237, 0.35);
        opacity: 0;
        visibility: hidden;
        transform: translateY(14px);
        transition: opacity 0.26s ease, transform 0.26s ease, visibility 0.26s ease;
    }

    #backToTop.show {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
    }

    .app-toast-stack {
        position: fixed;
        top: 0.95rem;
        right: 0.95rem;
        z-index: 1500;
        display: flex;
        flex-direction: column;
        gap: 0.52rem;
        pointer-events: none;
        width: min(360px, calc(100vw - 1.4rem));
    }

    .app-toast {
        pointer-events: auto;
        border-radius: 0.95rem;
        border: 1px solid rgba(255, 255, 255, 0.18);
        backdrop-filter: blur(20px);
        box-shadow: 0 18px 36px rgba(7, 8, 21, 0.42);
        color: #FBFBFF;
        padding: 0.78rem 0.88rem;
        transform: translateX(110%);
        opacity: 0;
        animation: toastIn 0.45s ease forwards;
        font-size: 0.9rem;
    }

    .app-toast.success {
        background: linear-gradient(125deg, rgba(34, 197, 94, 0.88), rgba(37, 99, 235, 0.85));
    }

    .app-toast.error {
        background: linear-gradient(125deg, rgba(239, 68, 68, 0.92), rgba(168, 20, 100, 0.9));
    }

    .app-toast.info {
        background: linear-gradient(125deg, rgba(124, 58, 237, 0.9), rgba(37, 99, 235, 0.88));
    }

    .app-toast.out {
        animation: toastOut 0.34s ease forwards;
    }

    @keyframes toastIn {
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }

    @keyframes toastOut {
        to {
            transform: translateX(110%);
            opacity: 0;
        }
    }

    .app-confirm-modal .modal-content {
        border-radius: 1rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(22, 24, 46, 0.96), rgba(11, 12, 24, 0.96));
        color: #EEF1FF;
        backdrop-filter: blur(20px);
    }

    .app-confirm-modal .modal-header,
    .app-confirm-modal .modal-footer {
        border-color: rgba(255, 255, 255, 0.11);
    }

    .app-confirm-modal .btn-close {
        filter: invert(1);
        opacity: 0.82;
    }

    .app-confirm-modal .btn-modal-secondary,
    .app-confirm-modal .btn-modal-danger {
        border: 0;
        border-radius: 0.8rem;
        min-height: 38px;
        padding: 0.4rem 0.82rem;
        font-weight: 700;
    }

    .app-confirm-modal .btn-modal-secondary {
        color: #E5E8FF;
        background: rgba(255, 255, 255, 0.12);
        border: 1px solid rgba(255, 255, 255, 0.22);
    }

    .app-confirm-modal .btn-modal-danger {
        color: #FFFFFF;
        background: linear-gradient(100deg, rgba(239, 68, 68, 0.95), rgba(236, 72, 153, 0.88));
        box-shadow: 0 12px 24px rgba(239, 68, 68, 0.32);
    }

    @media (max-width: 767.98px) {
        .shell-footer-inner {
            width: calc(100% - 1.2rem);
            flex-direction: column;
            text-align: center;
            padding-top: 0.2rem;
            padding-bottom: 0.2rem;
        }

        #backToTop {
            right: 0.7rem;
            bottom: 0.8rem;
        }

        .app-toast-stack {
            left: 0.7rem;
            right: 0.7rem;
            width: auto;
        }
    }
</style>
<footer class="bg-dark text-light py-3 mt-5 shell-footer">
    <div class="container shell-footer-inner">
        <p class="shell-copy">&copy; 2026 <strong>EventSphere</strong></p>
        <p class="shell-stack">Jakarta EE 10</p>
    </div>
</footer>

<button id="backToTop" type="button" aria-label="Back to top">Top</button>
<div id="globalToastStack" class="app-toast-stack" aria-live="polite" aria-atomic="true"></div>

<div class="modal fade app-confirm-modal" id="confirmActionModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Please confirm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="confirmActionText">Are you sure you want to continue?</div>
            <div class="modal-footer">
                <button type="button" class="btn-modal-secondary" data-bs-dismiss="modal">Keep it</button>
                <button type="button" class="btn-modal-danger" id="confirmActionBtn">Yes, continue</button>
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
        const prefersReducedMotion = win.matchMedia("(prefers-reduced-motion: reduce)").matches;
        const finePointer = win.matchMedia("(pointer:fine)").matches;

        const pageProgress = doc.getElementById("pageProgress");
        if (pageProgress) {
            pageProgress.style.width = "18%";
            doc.addEventListener("DOMContentLoaded", function () {
                pageProgress.style.width = "62%";
            });
            win.addEventListener("load", function () {
                pageProgress.style.width = "100%";
                setTimeout(function () {
                    pageProgress.style.opacity = "0.25";
                }, 260);
                setTimeout(function () {
                    pageProgress.style.opacity = "0";
                }, 920);
            });
        }

        function updateScrollProgress() {
            if (!pageProgress) {
                return;
            }
            const scrollTop = win.pageYOffset || doc.documentElement.scrollTop || 0;
            const scrollHeight = doc.documentElement.scrollHeight - doc.documentElement.clientHeight;
            if (scrollHeight <= 0) {
                return;
            }
            const ratio = Math.min(1, Math.max(0, scrollTop / scrollHeight));
            const width = Math.max(parseFloat(pageProgress.style.width) || 0, ratio * 100);
            pageProgress.style.width = width + "%";
        }

        win.addEventListener("scroll", updateScrollProgress, { passive: true });

        const navLinks = doc.querySelectorAll(".shell-link");
        const currentPath = win.location.pathname.replace(/\/+$/, "");
        navLinks.forEach(function (link) {
            let targetPath = "";
            try {
                targetPath = new URL(link.href, win.location.origin).pathname.replace(/\/+$/, "");
            } catch (error) {
                targetPath = "";
            }
            if (!targetPath) {
                return;
            }
            const isHome = /\/home$/.test(targetPath);
            const isActive = currentPath === targetPath || (!isHome && currentPath.indexOf(targetPath + "/") === 0);
            if (isActive) {
                link.classList.add("active-route");
            }
        });

        const navMain = doc.getElementById("navMain");
        if (navMain) {
            navMain.querySelectorAll("a").forEach(function (link) {
                link.addEventListener("click", function () {
                    if (win.innerWidth >= 992 || !navMain.classList.contains("show")) {
                        return;
                    }
                    navMain.classList.remove("show");
                    const toggler = doc.querySelector(".shell-toggler");
                    if (toggler) {
                        toggler.setAttribute("aria-expanded", "false");
                        toggler.classList.add("collapsed");
                    }
                });
            });
        }

        const navClock = doc.getElementById("navClock");
        if (navClock) {
            function updateClock() {
                const now = new Date();
                navClock.textContent = now.toLocaleTimeString([], { hour12: false });
            }
            updateClock();
            win.setInterval(updateClock, 1000);
        }

        const toastStack = doc.getElementById("globalToastStack");
        function pushToast(message, type) {
            if (!toastStack || !message) {
                return;
            }
            const toast = doc.createElement("div");
            toast.className = "app-toast " + (type || "info");
            toast.textContent = message;
            toastStack.appendChild(toast);
            win.setTimeout(function () {
                toast.classList.add("out");
                win.setTimeout(function () {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 340);
            }, 3000);
        }

        doc.querySelectorAll(".server-toast-data").forEach(function (el) {
            const text = (el.textContent || "").trim();
            const type = el.getAttribute("data-type") || "info";
            if (text) {
                pushToast(text, type);
            }
        });

        doc.addEventListener("pointerdown", function (event) {
            const target = event.target.closest("button, .btn, a[class*='btn']");
            if (!target) {
                return;
            }
            target.classList.add("ripple-host");
            const rect = target.getBoundingClientRect();
            const splash = doc.createElement("span");
            splash.className = "ripple-splash";
            const size = Math.max(rect.width, rect.height) * 1.2;
            splash.style.width = size + "px";
            splash.style.height = size + "px";
            splash.style.left = (event.clientX - rect.left - size / 2) + "px";
            splash.style.top = (event.clientY - rect.top - size / 2) + "px";
            target.appendChild(splash);
            win.setTimeout(function () {
                if (splash.parentNode) {
                    splash.parentNode.removeChild(splash);
                }
            }, 680);
        });

        if (!prefersReducedMotion && finePointer) {
            const tiltTargets = doc.querySelectorAll(".card, .metric-card, .hero-shell, .filter-shell, .detail-shell, .tickets-shell, .form-shell, .error-shell");
            tiltTargets.forEach(function (el) {
                el.classList.add("tilt-card");
                el.addEventListener("mousemove", function (event) {
                    const rect = el.getBoundingClientRect();
                    const px = (event.clientX - rect.left) / rect.width;
                    const py = (event.clientY - rect.top) / rect.height;
                    const rotateY = (px - 0.5) * 8;
                    const rotateX = (0.5 - py) * 8;
                    el.style.transform = "perspective(900px) rotateX(" + rotateX.toFixed(2) + "deg) rotateY(" + rotateY.toFixed(2) + "deg) translateZ(0)";
                });
                el.addEventListener("mouseleave", function () {
                    el.style.transform = "";
                });
            });
        }

        function parseCounterValue(text) {
            const cleaned = (text || "").replace(/[^0-9.-]/g, "");
            if (!cleaned) {
                return NaN;
            }
            return parseFloat(cleaned);
        }

        function formatCounter(template, value, decimals) {
            if (/\$/.test(template)) {
                return new Intl.NumberFormat("en-US", {
                    style: "currency",
                    currency: "USD",
                    maximumFractionDigits: Math.min(2, decimals)
                }).format(value);
            }
            if (/%/.test(template)) {
                return value.toFixed(decimals) + "%";
            }
            if (Math.abs(value) >= 1000 || template.indexOf(",") !== -1) {
                return new Intl.NumberFormat("en-US", {
                    maximumFractionDigits: decimals
                }).format(value);
            }
            return value.toFixed(decimals);
        }

        function animateCounter(el) {
            if (el.dataset.counterDone === "1") {
                return;
            }
            const template = (el.textContent || "").trim();
            const target = parseCounterValue(template);
            if (Number.isNaN(target)) {
                return;
            }
            const decimals = template.indexOf(".") !== -1 ? 2 : 0;
            const duration = 1200;
            const start = performance.now();
            function step(now) {
                const progress = Math.min(1, (now - start) / duration);
                const eased = 1 - Math.pow(1 - progress, 3);
                const current = target * eased;
                el.textContent = formatCounter(template, current, decimals);
                if (progress < 1) {
                    requestAnimationFrame(step);
                } else {
                    el.textContent = template;
                    el.dataset.counterDone = "1";
                }
            }
            requestAnimationFrame(step);
        }

        const counterTargets = doc.querySelectorAll(".metric-value, [data-counter], .counter-value");
        if (counterTargets.length && "IntersectionObserver" in win) {
            const observer = new IntersectionObserver(function (entries) {
                entries.forEach(function (entry) {
                    if (!entry.isIntersecting) {
                        return;
                    }
                    animateCounter(entry.target);
                    observer.unobserve(entry.target);
                });
            }, { threshold: 0.5 });
            counterTargets.forEach(function (el) { observer.observe(el); });
        } else {
            counterTargets.forEach(animateCounter);
        }

        doc.querySelectorAll(".kpi-card").forEach(function (card) {
            let spark = card.querySelector("canvas.kpi-sparkline");
            if (!spark) {
                spark = doc.createElement("canvas");
                spark.className = "kpi-sparkline";
                spark.width = 240;
                spark.height = 42;
                card.appendChild(spark);
            }
            const metric = card.querySelector(".metric-value");
            const targetValue = metric ? parseCounterValue(metric.textContent) : 0;
            const ctx = spark.getContext("2d");
            if (!ctx) {
                return;
            }
            const w = spark.width;
            const h = spark.height;
            ctx.clearRect(0, 0, w, h);
            const points = [];
            const base = Number.isNaN(targetValue) ? 50 : Math.max(15, Math.min(9999, targetValue));
            for (let i = 0; i < 16; i += 1) {
                const seed = Math.sin((i + 1) * 0.75) * 0.12 + Math.cos((i + 2) * 0.42) * 0.08;
                points.push(Math.max(0.15, Math.min(1, 0.3 + (i / 16) * 0.58 + seed + (base % 7) * 0.01)));
            }
            const grad = ctx.createLinearGradient(0, 0, w, 0);
            grad.addColorStop(0, "rgba(124, 58, 237, 0.95)");
            grad.addColorStop(0.5, "rgba(37, 99, 235, 0.92)");
            grad.addColorStop(1, "rgba(236, 72, 153, 0.95)");
            ctx.strokeStyle = grad;
            ctx.lineWidth = 2;
            ctx.beginPath();
            points.forEach(function (point, i) {
                const x = (i / (points.length - 1)) * w;
                const y = h - point * h;
                if (i === 0) {
                    ctx.moveTo(x, y);
                } else {
                    ctx.lineTo(x, y);
                }
            });
            ctx.stroke();

            ctx.lineTo(w, h);
            ctx.lineTo(0, h);
            ctx.closePath();
            const fill = ctx.createLinearGradient(0, 0, 0, h);
            fill.addColorStop(0, "rgba(124, 58, 237, 0.32)");
            fill.addColorStop(1, "rgba(124, 58, 237, 0)");
            ctx.fillStyle = fill;
            ctx.fill();
        });

        function tableToCsv(table) {
            const rows = Array.from(table.querySelectorAll("tr"));
            return rows.map(function (row) {
                const cols = Array.from(row.querySelectorAll("th,td"));
                return cols.map(function (cell) {
                    const text = (cell.textContent || "").replace(/\s+/g, " ").trim();
                    const escaped = text.replace(/"/g, '""');
                    return '"' + escaped + '"';
                }).join(",");
            }).join("\n");
        }

        doc.querySelectorAll("table").forEach(function (table, index) {
            if (table.dataset.csvReady === "1") {
                return;
            }
            table.dataset.csvReady = "1";
            const wrap = table.closest(".table-responsive") || table.parentElement;
            if (!wrap) {
                return;
            }
            const buttonWrap = doc.createElement("div");
            buttonWrap.className = "table-export-wrap";
            const button = doc.createElement("button");
            button.type = "button";
            button.className = "table-export-btn";
            button.textContent = "Export CSV";
            button.addEventListener("click", function () {
                const csv = tableToCsv(table);
                const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
                const url = URL.createObjectURL(blob);
                const link = doc.createElement("a");
                link.href = url;
                link.download = "table-export-" + (index + 1) + ".csv";
                doc.body.appendChild(link);
                link.click();
                doc.body.removeChild(link);
                URL.revokeObjectURL(url);
                pushToast("CSV exported", "success");
            });
            buttonWrap.appendChild(button);
            wrap.parentNode.insertBefore(buttonWrap, wrap);
        });

        const confirmModalEl = doc.getElementById("confirmActionModal");
        const confirmText = doc.getElementById("confirmActionText");
        const confirmActionBtn = doc.getElementById("confirmActionBtn");
        let pendingForm = null;
        let confirmModal = null;
        if (confirmModalEl && win.bootstrap) {
            confirmModal = new bootstrap.Modal(confirmModalEl);
        }

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
            const submitBtn = form.querySelector("button[type='submit'], input[type='submit']");
            const submitLabel = submitBtn ? (submitBtn.textContent || submitBtn.value || "").toLowerCase() : "";
            if (!/(delete|cancel)/.test(action + " " + submitLabel)) {
                return;
            }
            event.preventDefault();
            pendingForm = form;
            if (confirmText) {
                confirmText.textContent = /(cancel)/.test(action + " " + submitLabel)
                    ? "This action will cancel this item. Continue?"
                    : "This action cannot be undone. Do you want to proceed?";
            }
            confirmModal.show();
        });

        if (confirmActionBtn) {
            confirmActionBtn.addEventListener("click", function () {
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

        doc.querySelectorAll("table tbody").forEach(function (tbody) {
            if (tbody.querySelector("tr")) {
                return;
            }
            const table = tbody.closest("table");
            const columns = table ? table.querySelectorAll("thead th").length : 1;
            const row = doc.createElement("tr");
            const cell = doc.createElement("td");
            cell.colSpan = columns || 1;
            cell.innerHTML = '<div class="empty-state-inline"><div class="icon">*</div><div>No data available yet.</div></div>';
            row.appendChild(cell);
            tbody.appendChild(row);
        });

        const validationFields = doc.querySelectorAll("input:not([type='hidden']):not([type='checkbox']):not([type='radio']), textarea, select");
        validationFields.forEach(function (field) {
            if (field.classList.contains("no-live-validation")) {
                return;
            }
            const parent = field.parentElement;
            if (!parent) {
                return;
            }
            if (win.getComputedStyle(parent).position === "static") {
                parent.style.position = "relative";
            }
            let marker = parent.querySelector(".field-validation-mark[data-for='" + field.id + "']");
            if (!marker) {
                marker = doc.createElement("span");
                marker.className = "field-validation-mark";
                marker.setAttribute("aria-hidden", "true");
                marker.dataset.for = field.id || "field";
                parent.appendChild(marker);
                if (field.tagName !== "TEXTAREA") {
                    field.style.paddingRight = "2rem";
                }
            }

            function updateState() {
                const hasValue = (field.value || "").trim().length > 0;
                marker.classList.remove("is-valid", "is-invalid");
                if (!field.required && !hasValue) {
                    return;
                }
                if (field.checkValidity()) {
                    marker.classList.add("is-valid");
                }
            }

            ["input", "change", "blur"].forEach(function (evt) {
                field.addEventListener(evt, updateState);
            });
            updateState();
        });

        const backToTop = doc.getElementById("backToTop");
        function updateBackToTop() {
            if (!backToTop) {
                return;
            }
            if ((win.pageYOffset || doc.documentElement.scrollTop) > 320) {
                backToTop.classList.add("show");
            } else {
                backToTop.classList.remove("show");
            }
        }

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
