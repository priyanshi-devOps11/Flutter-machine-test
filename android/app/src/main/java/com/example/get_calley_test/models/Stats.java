package com.example.get_calley_test.models;

import java.util.List;

public class Stats {
    private int totalCalls;
    private int pendingCalls;
    private int completedCalls;
    private int scheduledCalls;
    private List<CallsByDay> callsByDay;

    public Stats() {}

    public int getTotalCalls() {
        return totalCalls;
    }

    public void setTotalCalls(int totalCalls) {
        this.totalCalls = totalCalls;
    }

    public int getPendingCalls() {
        return pendingCalls;
    }

    public void setPendingCalls(int pendingCalls) {
        this.pendingCalls = pendingCalls;
    }

    public int getCompletedCalls() {
        return completedCalls;
    }

    public void setCompletedCalls(int completedCalls) {
        this.completedCalls = completedCalls;
    }

    public int getScheduledCalls() {
        return scheduledCalls;
    }

    public void setScheduledCalls(int scheduledCalls) {
        this.scheduledCalls = scheduledCalls;
    }

    public List<CallsByDay> getCallsByDay() {
        return callsByDay;
    }

    public void setCallsByDay(List<CallsByDay> callsByDay) {
        this.callsByDay = callsByDay;
    }

    public static class CallsByDay {
        private String day;
        private int calls;

        public CallsByDay() {}

        public CallsByDay(String day, int calls) {
            this.day = day;
            this.calls = calls;
        }

        public String getDay() {
            return day;
        }

        public void setDay(String day) {
            this.day = day;
        }

        public int getCalls() {
            return calls;
        }

        public void setCalls(int calls) {
            this.calls = calls;
        }
    }
}