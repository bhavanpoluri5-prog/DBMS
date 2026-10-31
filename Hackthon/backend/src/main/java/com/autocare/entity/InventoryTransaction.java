package com.autocare.entity;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import com.autocare.enums.*;
import java.math.BigDecimal;
import java.time.*;

@Entity
@Table(name = "inventory_transactions", indexes = @Index(name = "idx_it_part", columnList = "spare_part_id"))
@Getter @Setter @NoArgsConstructor
public class InventoryTransaction {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false, fetch = FetchType.LAZY)
    @JoinColumn(name = "spare_part_id", nullable = false)
    private SparePart sparePart;

    /** Set when parts are consumed by a job. */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "service_request_id")
    private ServiceRequest serviceRequest;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TransactionType type;

    /** Positive = stock added, negative = stock consumed. */
    @Column(nullable = false)
    private Integer quantityChange;

    @CreationTimestamp
    @Column(updatable = false)
    private LocalDateTime createdAt;
}
