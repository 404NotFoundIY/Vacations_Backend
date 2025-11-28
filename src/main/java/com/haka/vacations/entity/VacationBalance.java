package com.haka.vacations.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.UUID;

@Entity
@Table(name = "vacation_balance")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class VacationBalance {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_user", nullable = false)
    private User user;

    @Column(nullable = false)
    private Integer ano;

    @Column(name = "dias_totais", nullable = false, precision = 5, scale = 2)
    private BigDecimal diasTotais;

    @Column(name = "dias_usados", nullable = false, precision = 5, scale = 2)
    private BigDecimal diasUsados = BigDecimal.ZERO;

    @Column(name = "dias_transitados", nullable = false, precision = 5, scale = 2)
    private BigDecimal diasTransitados = BigDecimal.ZERO;
}
