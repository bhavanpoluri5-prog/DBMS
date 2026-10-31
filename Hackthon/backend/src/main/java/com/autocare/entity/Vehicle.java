package com.autocare.entity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.autocare.enums.*;
import java.math.BigDecimal;
import java.time.*;

@Entity
@Table(name = "vehicles", indexes = @Index(name = "idx_vehicle_owner", columnList = "owner_id"))
@Getter @Setter @NoArgsConstructor
public class Vehicle {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(nullable = false, unique = true, length = 20)
    private String registrationNumber;

    @Column(nullable = false, length = 60)
    private String manufacturer;

    @Column(nullable = false, length = 60)
    private String model;

    @Column(nullable = false)
    private Integer manufacturingYear;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private FuelType fuelType;

    @Column(nullable = false)
    private Integer odometerReading;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private VehicleCategory category;

    private LocalDate lastServiceDate;
}
