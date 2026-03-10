package com.eventapp.security;

import com.eventapp.model.User;
import com.eventapp.service.UserService;
import com.eventapp.util.PasswordUtil;
import jakarta.ejb.EJB;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.security.enterprise.credential.Credential;
import jakarta.security.enterprise.credential.UsernamePasswordCredential;
import jakarta.security.enterprise.identitystore.CredentialValidationResult;
import jakarta.security.enterprise.identitystore.IdentityStore;

import java.util.Set;

@ApplicationScoped
public class BcryptIdentityStore implements IdentityStore {

    @EJB
    private UserService userService;

    @Override
    public CredentialValidationResult validate(Credential credential) {
        if (!(credential instanceof UsernamePasswordCredential usernamePasswordCredential)) {
            return CredentialValidationResult.INVALID_RESULT;
        }

        String email = usernamePasswordCredential.getCaller();
        String password = usernamePasswordCredential.getPasswordAsString();

        User user = userService.getUserByEmail(email);
        if (user == null || !user.isActive()) {
            return CredentialValidationResult.INVALID_RESULT;
        }

        boolean valid = PasswordUtil.verifyPassword(password, user.getPasswordHash());
        if (!valid) {
            return CredentialValidationResult.INVALID_RESULT;
        }

        return new CredentialValidationResult(
                user.getEmail(),
                Set.of(user.getRole().name())
        );
    }
}
