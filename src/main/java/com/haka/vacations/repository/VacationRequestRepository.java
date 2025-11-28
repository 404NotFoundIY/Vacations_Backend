package com.haka.vacations.repository;

import com.haka.vacations.entity.VacationRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface VacationRequestRepository extends JpaRepository<VacationRequest, UUID> {
    
    List<VacationRequest> findByUserId(UUID userId);
    
    List<VacationRequest> findByStatus(String status);
}
