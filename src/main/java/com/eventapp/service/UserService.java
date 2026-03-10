package com.eventapp.service;

import com.eventapp.model.User;
import com.eventapp.model.UserRole;
import com.eventapp.repository.UserRepository;
import com.eventapp.util.ValidationUtil;
import jakarta.ejb.Stateless;
import jakarta.inject.Inject;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

@Stateless
public class UserService {

    @Inject
    private UserRepository userRepository;

    /**
     * Registers a new user after validating fields.
     *
     * @param name user full name
     * @param email user email
     * @param password plain password
     * @param role user role
     * @return saved user
     */
    public User registerUser(String name, String email, String password, UserRole role) {
        if (!ValidationUtil.between(name, 2, 120)) {
            throw new IllegalArgumentException("Name must be between 2 and 120 characters.");
        }
        if (!ValidationUtil.isEmail(email)) {
            throw new IllegalArgumentException("Invalid email format.");
        }
        if (!ValidationUtil.between(password, 8, 128)) {
            throw new IllegalArgumentException("Password must be between 8 and 128 characters.");
        }
        if (role == null) {
            throw new IllegalArgumentException("Role is required.");
        }
        if (userRepository.findByEmail(email).isPresent()) {
            throw new IllegalArgumentException("Email already exists.");
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPasswordHash(hashPassword(password));
        user.setRole(role);
        user.setActive(true);

        return userRepository.save(user);
    }

    /**
     * Authenticates user using email and password.
     *
     * @param email email
     * @param password plain password
     * @return authenticated user, or null if invalid
     */
    public User login(String email, String password) {
        if (!ValidationUtil.isEmail(email) || ValidationUtil.isBlank(password)) {
            return null;
        }

        return userRepository.findByEmail(email)
                .filter(User::isActive)
                .filter(u -> BCrypt.checkpw(password, u.getPasswordHash()))
                .orElse(null);
    }

    /**
     * Finds user by id.
     *
     * @param id user id
     * @return user or null
     */
    public User getUserById(Long id) {
        if (id == null || id <= 0) {
            return null;
        }
        return userRepository.findById(id).orElse(null);
    }

    /**
     * Returns all users.
     *
     * @return users list
     */
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    /**
     * Updates an existing user.
     *
     * @param user user entity
     * @return updated user
     */
    public User updateUser(User user) {
        if (user == null || user.getId() == null) {
            throw new IllegalArgumentException("User id is required.");
        }
        if (!ValidationUtil.between(user.getName(), 2, 120)) {
            throw new IllegalArgumentException("Invalid name.");
        }
        if (!ValidationUtil.isEmail(user.getEmail())) {
            throw new IllegalArgumentException("Invalid email.");
        }
        if (user.getRole() == null) {
            throw new IllegalArgumentException("Role is required.");
        }

        return userRepository.save(user);
    }

    /**
     * Deletes a user by id.
     *
     * @param id user id
     */
    public void deleteUser(Long id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Valid user id is required.");
        }

        User existing = userRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("User not found."));
        userRepository.delete(existing);
    }

    /**
     * Hashes a password using BCrypt.
     *
     * @param password plain password
     * @return hashed password
     */
    public String hashPassword(String password) {
        if (!ValidationUtil.between(password, 8, 128)) {
            throw new IllegalArgumentException("Password length must be between 8 and 128 characters.");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt());
    }

    /**
     * Finds user by email.
     *
     * @param email email
     * @return user or null
     */
    public User getUserByEmail(String email) {
        if (!ValidationUtil.isEmail(email)) {
            return null;
        }
        return userRepository.findByEmail(email).orElse(null);
    }

    /**
     * Counts users.
     *
     * @return total users
     */
    public long countUsers() {
        return userRepository.countAll();
    }
}
