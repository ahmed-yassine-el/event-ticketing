<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Edit Event"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .organizer-form-page .form-shell {
        padding: clamp(1rem, 3vw, 1.5rem);
    }

    .form-title {
        margin: 0 0 0.8rem;
        font-size: clamp(1.8rem, 3vw, 2.4rem);
    }

    .location-field-wrap {
        position: relative;
    }

    .location-loading {
        position: absolute;
        right: 0.7rem;
        top: 2.35rem;
        color: #FF6B35;
    }

    .location-suggestions {
        position: absolute;
        left: 0;
        right: 0;
        top: calc(100% + 0.35rem);
        z-index: 30;
        border: 1px solid #E2E8F0;
        border-radius: 12px;
        background: #FFFFFF;
        box-shadow: var(--shadow-card);
        max-height: 260px;
        overflow: auto;
        padding: 0.4rem;
    }

    .location-item {
        width: 100%;
        border: 1px solid transparent;
        background: #FFFFFF;
        border-radius: 10px;
        text-align: left;
        padding: 0.55rem 0.6rem;
        margin-bottom: 0.25rem;
    }

    .location-item:hover {
        border-color: #FFD3C0;
        background: #FFF7F3;
    }

    .location-name {
        display: block;
        color: #1A202C;
        font-weight: 700;
    }

    .location-country {
        display: block;
        color: #64748B;
        font-size: 0.82rem;
    }

    .location-map-shell {
        border: 1px solid #E2E8F0;
        border-radius: 14px;
        overflow: hidden;
        background: #FFFFFF;
    }

    .location-map {
        height: 320px;
        width: 100%;
    }
</style>

<section class="organizer-form-page dashboard-layout">
    <aside class="dashboard-sidebar">
        <h2>Organizer</h2>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/dashboard">Dashboard</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/create-event">Create Event</a>
        <a class="sidebar-link active" href="${pageContext.request.contextPath}/organizer/edit-event?id=${event.id}">Edit Event</a>
        <a class="sidebar-link" href="${pageContext.request.contextPath}/organizer/stats">Statistics</a>
    </aside>

    <div class="dashboard-content">
        <div class="form-shell">
            <h1 class="form-title">Edit Event</h1>
            <form action="${pageContext.request.contextPath}/organizer/edit-event" method="post" class="row g-3">
                <input type="hidden" name="csrfToken" value="${csrfToken}">
                <input type="hidden" name="id" value="${event.id}">
                <div class="col-md-6">
                    <label class="form-label" for="eventTitle">Title</label>
                    <input type="text" id="eventTitle" class="form-control" name="title" value="${fn:escapeXml(event.title)}" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="eventCategory">Category</label>
                    <input type="text" id="eventCategory" class="form-control" name="category" value="${fn:escapeXml(event.category)}" required>
                </div>
                <div class="col-12">
                    <label class="form-label" for="eventDescription">Description</label>
                    <textarea id="eventDescription" class="form-control" name="description" rows="4" required>${fn:escapeXml(event.description)}</textarea>
                </div>
                <div class="col-md-6 location-field-wrap">
                    <label class="form-label" for="eventLocation">Search Location</label>
                    <input type="text" id="eventLocation" class="form-control" name="location" value="${fn:escapeXml(event.location)}" required autocomplete="off">
                    <input type="hidden" id="eventLatitude" name="latitude" value="${event.latitude}">
                    <input type="hidden" id="eventLongitude" name="longitude" value="${event.longitude}">
                    <div id="locationLoading" class="location-loading d-none" aria-live="polite">
                        <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                    </div>
                    <div id="locationSuggestions" class="location-suggestions d-none" role="listbox" aria-label="Location suggestions"></div>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="eventDate">Event Date</label>
                    <input type="datetime-local" id="eventDate" class="form-control" name="eventDate" value="${fn:substring(event.eventDate, 0, 16)}" required>
                </div>
                <div class="col-12 ${event.latitude == null or event.longitude == null ? 'd-none' : ''}" id="locationMapWrap">
                    <div class="location-map-shell">
                        <div id="eventLocationMap" class="location-map" aria-label="Selected event location"></div>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="eventTotalTickets">Total Tickets</label>
                    <input type="number" id="eventTotalTickets" class="form-control" name="totalTickets" value="${event.totalTickets}" required min="1">
                </div>
                <div class="col-md-6">
                    <label class="form-label" for="eventPrice">Price</label>
                    <input type="number" id="eventPrice" step="0.01" class="form-control" name="price" value="${event.price}" required min="0">
                </div>
                <div class="col-12 d-grid">
                    <button class="btn-vivid" type="submit">Update Event</button>
                </div>
            </form>
        </div>
    </div>
</section>

<script>
    (function () {
        const input = document.getElementById("eventLocation");
        const latitudeInput = document.getElementById("eventLatitude");
        const longitudeInput = document.getElementById("eventLongitude");
        const suggestionsBox = document.getElementById("locationSuggestions");
        const loading = document.getElementById("locationLoading");
        const mapWrap = document.getElementById("locationMapWrap");
        const mapElement = document.getElementById("eventLocationMap");
        if (!input || !latitudeInput || !longitudeInput || !suggestionsBox || !loading || !mapWrap || !mapElement) {
            return;
        }

        const apiUrl = "https://nominatim.openstreetmap.org/search?format=json&addressdetails=1&limit=8&q=";
        let debounceTimer = null;
        let requestIndex = 0;
        let selectedLabel = input.value.trim();
        let map = null;
        let marker = null;

        function hideSuggestions() {
            suggestionsBox.classList.add("d-none");
            suggestionsBox.innerHTML = "";
        }

        function setLoading(isLoading) {
            loading.classList.toggle("d-none", !isLoading);
        }

        function showMap(lat, lng, label) {
            if (!window.L || !Number.isFinite(lat) || !Number.isFinite(lng)) {
                return;
            }
            mapWrap.classList.remove("d-none");
            if (!map) {
                map = L.map(mapElement, { scrollWheelZoom: true }).setView([lat, lng], 13);
                L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
                    attribution: "&copy; OpenStreetMap contributors",
                    maxZoom: 20
                }).addTo(map);
            } else {
                map.setView([lat, lng], 13);
            }

            if (!marker) {
                marker = L.marker([lat, lng]).addTo(map);
            } else {
                marker.setLatLng([lat, lng]);
            }
            marker.bindPopup(label || "Selected location").openPopup();
            window.setTimeout(function () {
                map.invalidateSize();
            }, 80);
        }

        function selectLocation(item) {
            const lat = Number.parseFloat(item.lat);
            const lng = Number.parseFloat(item.lon);
            const primaryName = (item.name && item.name.trim()) ? item.name.trim() : (item.display_name || "").split(",")[0].trim();
            input.value = primaryName;
            latitudeInput.value = Number.isFinite(lat) ? String(lat) : "";
            longitudeInput.value = Number.isFinite(lng) ? String(lng) : "";
            selectedLabel = input.value;
            hideSuggestions();
            showMap(lat, lng, primaryName);
        }

        function renderSuggestions(items) {
            if (!items.length) {
                hideSuggestions();
                return;
            }
            suggestionsBox.innerHTML = "";
            items.forEach(function (item) {
                const option = document.createElement("button");
                option.type = "button";
                option.className = "location-item";
                const placeName = (item.name && item.name.trim()) ? item.name.trim() : (item.display_name || "").split(",")[0].trim();
                const countryName = (item.address && item.address.country) ? item.address.country : ((item.display_name || "").split(",").slice(-1)[0] || "").trim();
                option.innerHTML = "<span class='location-name'></span><span class='location-country'></span>";
                option.querySelector(".location-name").textContent = placeName || "Unknown place";
                option.querySelector(".location-country").textContent = countryName || "Unknown country";
                option.addEventListener("click", function () {
                    selectLocation(item);
                });
                suggestionsBox.appendChild(option);
            });
            suggestionsBox.classList.remove("d-none");
        }

        input.addEventListener("input", function () {
            const query = input.value.trim();
            if (query !== selectedLabel) {
                latitudeInput.value = "";
                longitudeInput.value = "";
                mapWrap.classList.add("d-none");
            }
            if (debounceTimer) {
                window.clearTimeout(debounceTimer);
            }
            if (query.length < 2) {
                hideSuggestions();
                setLoading(false);
                return;
            }

            debounceTimer = window.setTimeout(function () {
                const currentRequest = ++requestIndex;
                setLoading(true);
                fetch(apiUrl + encodeURIComponent(query), {
                    headers: {
                        "Accept": "application/json",
                        "Accept-Language": "en"
                    }
                })
                    .then(function (response) {
                        if (!response.ok) {
                            throw new Error("Unable to load location suggestions.");
                        }
                        return response.json();
                    })
                    .then(function (data) {
                        if (currentRequest !== requestIndex) {
                            return;
                        }
                        renderSuggestions(Array.isArray(data) ? data : []);
                    })
                    .catch(function () {
                        hideSuggestions();
                    })
                    .finally(function () {
                        if (currentRequest === requestIndex) {
                            setLoading(false);
                        }
                    });
            }, 300);
        });

        document.addEventListener("click", function (event) {
            if (!event.target.closest(".location-field-wrap")) {
                hideSuggestions();
            }
        });

        const initialLat = Number.parseFloat(latitudeInput.value);
        const initialLng = Number.parseFloat(longitudeInput.value);
        if (Number.isFinite(initialLat) && Number.isFinite(initialLng)) {
            showMap(initialLat, initialLng, input.value.trim());
        }
    })();
</script>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
