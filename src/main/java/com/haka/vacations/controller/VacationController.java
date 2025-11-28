package com.haka.vacations.controller;

import com.haka.vacations.entity.VacationRequest;
import com.haka.vacations.repository.VacationRequestRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/vacations")
@RequiredArgsConstructor
public class VacationController {

    private final VacationRequestRepository vacationRequestRepository;

    @GetMapping
    @PreAuthorize("hasAnyRole('USER', 'TL', 'RH', 'ADMIN')")
    public ResponseEntity<List<VacationRequest>> getAllVacationRequests() {
        return ResponseEntity.ok(vacationRequestRepository.findAll());
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('USER', 'TL', 'RH', 'ADMIN')")
    public ResponseEntity<VacationRequest> getVacationRequestById(@PathVariable UUID id) {
        return vacationRequestRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    @PreAuthorize("hasAnyRole('USER', 'TL', 'RH', 'ADMIN')")
    public ResponseEntity<List<VacationRequest>> getVacationRequestsByUser(@PathVariable UUID userId) {
        return ResponseEntity.ok(vacationRequestRepository.findByUserId(userId));
    }

    @GetMapping("/status/{status}")
    @PreAuthorize("hasAnyRole('TL', 'RH', 'ADMIN')")
    public ResponseEntity<List<VacationRequest>> getVacationRequestsByStatus(@PathVariable String status) {
        return ResponseEntity.ok(vacationRequestRepository.findByStatus(status));
    }
}
