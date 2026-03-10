package com.eventapp.service;

import com.eventapp.model.Event;
import com.eventapp.model.EventDTO;
import com.eventapp.model.EventStatus;
import com.eventapp.model.User;
import com.eventapp.repository.EventRepository;
import com.eventapp.repository.UserRepository;
import com.eventapp.util.ValidationUtil;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Stateless
public class EventService {

    @Inject
    private EventRepository eventRepository;

    @Inject
    private UserRepository userRepository;

    /**
     * Creates an event for a given organizer.
     *
     * @param eventDTO event payload
     * @param organizerId organizer user id
     * @return created event
     */
    public Event createEvent(EventDTO eventDTO, Long organizerId) {
        validateEventDTO(eventDTO);

        if (organizerId == null || organizerId <= 0) {
            throw new IllegalArgumentException("Organizer id is required.");
        }

        User organizer = userRepository.findById(organizerId)
                .orElseThrow(() -> new IllegalArgumentException("Organizer not found."));

        Event event = new Event();
        applyDto(event, eventDTO);
        event.setOrganizer(organizer);
        event.setAvailableTickets(eventDTO.getTotalTickets());
        event.setStatus(EventStatus.PENDING);

        return eventRepository.save(event);
    }

    /**
     * Updates an existing event.
     *
     * @param id event id
     * @param eventDTO update payload
     * @return updated event
     */
    public Event updateEvent(Long id, EventDTO eventDTO) {
        validateEventDTO(eventDTO);

        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Event id is required.");
        }

        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Event not found."));

        int sold = event.getTotalTickets() - event.getAvailableTickets();
        if (eventDTO.getTotalTickets() < sold) {
            throw new IllegalArgumentException("Total tickets cannot be less than sold tickets.");
        }

        applyDto(event, eventDTO);
        event.setAvailableTickets(eventDTO.getTotalTickets() - sold);

        return eventRepository.save(event);
    }

    /**
     * Deletes an event by id.
     *
     * @param id event id
     */
    public void deleteEvent(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Event id is required.");
        }

        Event event = eventRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Event not found."));
        eventRepository.delete(event);
    }

    /**
     * Gets all approved events.
     *
     * @return approved events
     */
    public List<Event> getAllApprovedEvents() {
        return eventRepository.findAllApproved();
    }

    /**
     * Gets events by organizer.
     *
     * @param organizerId organizer id
     * @return organizer events
     */
    public List<Event> getEventsByOrganizer(Long organizerId) {
        if (organizerId == null || organizerId <= 0) {
            throw new IllegalArgumentException("Organizer id is required.");
        }
        return eventRepository.findByOrganizer(organizerId);
    }

    /**
     * Searches approved events by category, location, and date.
     *
     * @param category optional category
     * @param location optional location
     * @param date optional minimum date
     * @return matching events
     */
    public List<Event> searchEvents(String category, String location, LocalDateTime date) {
        return eventRepository.search(category, location, date);
    }

    /**
     * Approves an event.
     *
     * @param id event id
     * @return updated event
     */
    public Event approveEvent(Long id) {
        Event event = getExistingEvent(id);
        event.setStatus(EventStatus.APPROVED);
        return eventRepository.save(event);
    }

    /**
     * Rejects an event by setting status to CANCELLED.
     *
     * @param id event id
     * @return updated event
     */
    public Event rejectEvent(Long id) {
        Event event = getExistingEvent(id);
        event.setStatus(EventStatus.CANCELLED);
        return eventRepository.save(event);
    }

    /**
     * Decrements available tickets by one.
     *
     * @param eventId event id
     */
    public void decrementAvailableTickets(Long eventId) {
        Event event = getExistingEvent(eventId);

        if (event.getAvailableTickets() == null || event.getAvailableTickets() <= 0) {
            throw new IllegalStateException("No tickets available.");
        }

        event.setAvailableTickets(event.getAvailableTickets() - 1);
        eventRepository.save(event);
    }

    /**
     * Finds event by id.
     *
     * @param id event id
     * @return event or null
     */
    public Event getEventById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        return eventRepository.findById(id).orElse(null);
    }

    /**
     * Returns pending events.
     *
     * @return pending event list
     */
    public List<Event> getPendingEvents() {
        return eventRepository.findPending();
    }

    /**
     * Returns approved events with pagination.
     *
     * @param page zero-based page index
     * @param size page size
     * @return page result
     */
    public List<Event> getApprovedEventsPage(int page, int size) {
        if (page < 0 || size <= 0) {
            throw new IllegalArgumentException("Invalid pagination values.");
        }
        return eventRepository.findApproved(page, size);
    }

    /**
     * Counts total events.
     *
     * @return total events
     */
    public long countEvents() {
        return eventRepository.countAll();
    }

    private Event getExistingEvent(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Event id is required.");
        }
        return eventRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Event not found."));
    }

    private void validateEventDTO(EventDTO eventDTO) {
        if (eventDTO == null) {
            throw new IllegalArgumentException("Event payload is required.");
        }
        if (!ValidationUtil.between(eventDTO.getTitle(), 3, 200)) {
            throw new IllegalArgumentException("Title must be between 3 and 200 characters.");
        }
        if (!ValidationUtil.between(eventDTO.getDescription(), 10, 2000)) {
            throw new IllegalArgumentException("Description must be between 10 and 2000 characters.");
        }
        if (!ValidationUtil.between(eventDTO.getCategory(), 2, 100)) {
            throw new IllegalArgumentException("Category must be between 2 and 100 characters.");
        }
        if (!ValidationUtil.between(eventDTO.getLocation(), 2, 200)) {
            throw new IllegalArgumentException("Location must be between 2 and 200 characters.");
        }
        if (eventDTO.getEventDate() == null || eventDTO.getEventDate().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Event date must be in the future.");
        }
        if (eventDTO.getTotalTickets() == null || eventDTO.getTotalTickets() <= 0) {
            throw new IllegalArgumentException("Total tickets must be greater than zero.");
        }
        if (eventDTO.getPrice() == null || eventDTO.getPrice().compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Price must be zero or positive.");
        }
    }

    private void applyDto(Event event, EventDTO eventDTO) {
        event.setTitle(eventDTO.getTitle().trim());
        event.setDescription(eventDTO.getDescription().trim());
        event.setCategory(eventDTO.getCategory().trim());
        event.setLocation(eventDTO.getLocation().trim());
        event.setEventDate(eventDTO.getEventDate());
        event.setTotalTickets(eventDTO.getTotalTickets());
        event.setPrice(eventDTO.getPrice());
    }
}
