package com.autocare.entity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.autocare.enums.*;
import java.math.BigDecimal;
import java.time.*;

@Entity
@Table(name = "maintenance_records", indexes = @Index(name = "idx_mr_vehicle", columnList = "vehicle_id"))
@Getter @Setter @NoArgsConstructor
public class MaintenanceRecord {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_request_id")
    private ServiceRequest serviceRequest;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ServiceCategory category;

    @Column(nullable = false)
    private Integer odometerReading;

    @Column(nullable = false)
    private LocalDate serviceDate;

    @Column(length = 1000)
    private String notes;
}
