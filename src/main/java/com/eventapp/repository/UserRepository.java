package com.eventapp.repository;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@ApplicationScoped
public class UserRepository {

    @PersistenceContext(unitName = "eventPU")
    private EntityManager entityManager;

    public User save(User user) {
        if (user.getId() == null) {
            entityManager.persist(user);
            return user;
        }
        return entityManager.merge(user);
    }

    public Optional<User> findById(Long id) {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u WHERE u.id = :id", User.class)
                .setParameter("id", id)
                .setMaxResults(1)
                .getResultList();
        initializeRelationships(users);
        return users.stream().findFirst();
    }

    public Optional<User> findByEmail(String email) {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u WHERE lower(u.email) = lower(:email)", User.class)
                .setParameter("email", email)
                .setMaxResults(1)
                .getResultList();
        initializeRelationships(users);
        return users.stream().findFirst();
    }

    public List<User> findAll() {
        List<User> users = entityManager.createQuery(
                        "SELECT u FROM User u ORDER BY u.createdAt DESC", User.class)
                .getResultList();
        initializeRelationships(users);
        return users;
    }

    public long countAll() {
        return entityManager.createQuery("SELECT COUNT(u) FROM User u", Long.class)
                .getSingleResult();
    }

    public long countByRole(UserRole role) {
        return entityManager.createQuery(
                        "SELECT COUNT(u) FROM User u WHERE u.role = :role", Long.class)
                .setParameter("role", role)
                .getSingleResult();
    }

    public void delete(User user) {
        User managed = entityManager.contains(user) ? user : entityManager.merge(user);
        entityManager.remove(managed);
    }

    private void initializeRelationships(List<User> users) {
        if (users == null || users.isEmpty()) {
            return;
        }

        List<Long> ids = users.stream()
                .map(User::getId)
                .collect(Collectors.toList());

        entityManager.createQuery(
                        "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.organizedEvents WHERE u.id IN :ids",
                        User.class)
                .setParameter("ids", ids)
                .getResultList();

        entityManager.createQuery(
                        "SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.participantTickets WHERE u.id IN :ids",
                        User.class)
                .setParameter("ids", ids)
                .getResultList();
    }
}
