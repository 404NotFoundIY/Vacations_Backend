package com.haka.vacations.service;

import com.haka.vacations.dto.AuthRequest;
import com.haka.vacations.dto.AuthResponse;
import com.haka.vacations.dto.RegisterRequest;
import com.haka.vacations.entity.Profile;
import com.haka.vacations.entity.User;
import com.haka.vacations.entity.UserProfile;
import com.haka.vacations.repository.ProfileRepository;
import com.haka.vacations.repository.UserProfileRepository;
import com.haka.vacations.repository.UserRepository;
import com.haka.vacations.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final ProfileRepository profileRepository;
    private final UserProfileRepository userProfileRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;
    private final CustomUserDetailsService userDetailsService;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setNome(request.getNome());
        user.setEmail(request.getEmail());
        user.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        user.setAtivo(true);
        user.setDataAdmissao(request.getDataAdmissao());

        user = userRepository.save(user);

        Profile profile = profileRepository.findByNome(request.getProfileNome())
                .orElseThrow(() -> new IllegalArgumentException("Profile not found"));

        UserProfile userProfile = new UserProfile();
        userProfile.setUser(user);
        userProfile.setProfile(profile);
        userProfileRepository.save(userProfile);

        UserDetails userDetails = userDetailsService.loadUserByUsername(user.getEmail());
        String token = jwtUtil.generateToken(userDetails);

        return new AuthResponse(token, user.getEmail(), user.getNome());
    }

    public AuthResponse login(AuthRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
        );

        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        UserDetails userDetails = userDetailsService.loadUserByUsername(request.getEmail());
        String token = jwtUtil.generateToken(userDetails);

        return new AuthResponse(token, user.getEmail(), user.getNome());
    }
}
