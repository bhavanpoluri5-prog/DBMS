package com.autocare.enums;

public enum ServiceStatus {
    BOOKED, APPROVED, ASSIGNED, IN_PROGRESS, COMPLETED, DELIVERED, REJECTED;

    /** Allowed workflow: BOOKED -> APPROVED -> ASSIGNED -> IN_PROGRESS -> COMPLETED -> DELIVERED (BOOKED may be REJECTED). */
    public boolean canTransitionTo(ServiceStatus next) {
        return switch (this) {
            case BOOKED -> next == APPROVED || next == REJECTED;
            case APPROVED -> next == ASSIGNED;
            case ASSIGNED -> next == IN_PROGRESS;
            case IN_PROGRESS -> next == COMPLETED;
            case COMPLETED -> next == DELIVERED;
            case DELIVERED, REJECTED -> false;
        };
    }
}
