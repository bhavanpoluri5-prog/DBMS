package com.autocare.entity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.autocare.enums.*;
import java.math.BigDecimal;
import java.time.*;

@Entity
@Table(name = "service_requests", indexes = {
    @Index(name = "idx_sr_customer", columnList = "customer_id"),
    @Index(name = "idx_sr_status", columnList = "status")})
@Getter @Setter @NoArgsConstructor
public class ServiceRequest {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Unique human-readable booking ID, e.g. SRV-20261030-A1B2C3 */
    @Column(nullable = false, unique = true, length = 30)
    private String bookingCode;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "customer_id", nullable = false)
    private User customer;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "vehicle_id", nullable = false)
    private Vehicle vehicle;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private ServiceCategory category;

    @Column(length = 1000)
    private String problemDescription;

    @Column(nullable = false)
    private LocalDate preferredDate;

    @Column(nullable = false)
    private Integer odometerReading;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ServiceStatus status = ServiceStatus.BOOKED;

    @Column(length = 500)
    private String adminRemarks;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;
}
