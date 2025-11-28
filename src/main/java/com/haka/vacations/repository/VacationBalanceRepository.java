package com.haka.vacations.repository;

import com.haka.vacations.entity.VacationBalance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface VacationBalanceRepository extends JpaRepository<VacationBalance, UUID> {
    
    List<VacationBalance> findByUserId(UUID userId);
    
    Optional<VacationBalance> findByUserIdAndAno(UUID userId, Integer ano);
}
