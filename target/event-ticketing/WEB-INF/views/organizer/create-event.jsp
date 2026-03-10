<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Create Event"/>
<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<style>
    .organizer-form-page {
        --p1: #7C3AED;
        --p2: #2563EB;
        --p3: #EC4899;
    }

    .organizer-form-page .form-shell {
        border-radius: 1.25rem;
        border: 1px solid rgba(255, 255, 255, 0.2);
        background: linear-gradient(145deg, rgba(255, 255, 255, 0.12), rgba(255, 255, 255, 0.04));
        backdrop-filter: blur(20px);
        box-shadow: 0 28px 46px rgba(7, 8, 20, 0.4);
        padding: clamp(1.1rem, 2.6vw, 2rem);
    }

    .organizer-form-page .form-title {
        margin: 0 0 0.95rem;
        font-family: "Syne", sans-serif;
        font-size: clamp(1.55rem, 3.4vw, 2.3rem);
        line-height: 1.08;
        background: linear-gradient(115deg, var(--p1), var(--p2), var(--p3));
        -webkit-background-clip: text;
        background-clip: text;
        color: transparent;
    }

    .organizer-form-page .form-label {
        font-size: 0.77rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        color: rgba(214, 219, 248, 0.77);
        margin-bottom: 0.34rem;
    }

    .organizer-form-page .form-control,
    .organizer-form-page .form-select {
        border-radius: 0.9rem;
        border: 1px solid rgba(255, 255, 255, 0.22);
        background: rgba(8, 10, 24, 0.68);
        color: #F4F5FF;
        min-height: 46px;
        padding: 0.6rem 0.8rem;
    }

    .organizer-form-page textarea.form-control {
        min-height: 130px;
        resize: vertical;
    }

    .organizer-form-page .form-control:focus,
    .organizer-form-page .form-select:focus {
        border-color: rgba(236, 72, 153, 0.9);
        box-shadow: 0 0 0 0.18rem rgba(124, 58, 237, 0.25);
        background: rgba(10, 13, 30, 0.9);
        color: #FFFFFF;
    }

    .organizer-form-page .btn-vivid {
        border: 0;
        border-radius: 0.9rem;
        min-height: 48px;
        width: 100%;
        font-weight: 700;
        color: #FFFFFF;
        background: linear-gradient(100deg, var(--p1), var(--p2), var(--p3));
        box-shadow: 0 18px 31px rgba(124, 58, 237, 0.32);
        transition: transform 0.24s ease, box-shadow 0.24s ease;
    }

    .organizer-form-page .btn-vivid:hover {
        transform: translateY(-2px);
        box-shadow: 0 24px 36px rgba(236, 72, 153, 0.34);
    }
</style>

<section class="organizer-form-page">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="form-shell">
                <h1 class="form-title">Create Event</h1>
                <form action="${pageContext.request.contextPath}/organizer/create-event" method="post" class="row g-3">
                    <input type="hidden" name="csrfToken" value="${csrfToken}">
                    <div class="col-md-6">
                        <label class="form-label" for="eventTitle">Title</label>
                        <input type="text" id="eventTitle" class="form-control" name="title" required maxlength="200">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="eventCategory">Category</label>
                        <input type="text" id="eventCategory" class="form-control" name="category" required maxlength="100">
                    </div>
                    <div class="col-12">
                        <label class="form-label" for="eventDescription">Description</label>
                        <textarea id="eventDescription" class="form-control" name="description" rows="4" required maxlength="2000"></textarea>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="eventLocation">Location</label>
                        <input type="text" id="eventLocation" class="form-control" name="location" required maxlength="200">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="eventDate">Event Date</label>
                        <input type="datetime-local" id="eventDate" class="form-control" name="eventDate" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="eventTotalTickets">Total Tickets</label>
                        <input type="number" id="eventTotalTickets" class="form-control" name="totalTickets" min="1" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" for="eventPrice">Price</label>
                        <input type="number" id="eventPrice" step="0.01" class="form-control" name="price" min="0" required>
                    </div>
                    <div class="col-12 d-grid">
                        <button class="btn-vivid" type="submit">Submit Event</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</section>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
