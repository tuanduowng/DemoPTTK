
package model;

import java.time.LocalDateTime;

public class Showtime {

    private Movie movie;
    private Room room;
    private Format format;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private String saleStatus;

    public Showtime() {
    }

    public Showtime(Movie movie, Room room, Format format,
                    LocalDateTime startAt, LocalDateTime endAt,
                    String saleStatus) {

        this.movie = movie;
        this.room = room;
        this.format = format;
        this.startAt = startAt;
        this.endAt = endAt;
        this.saleStatus = saleStatus;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public Room getRoom() {
        return room;
    }

    public void setRoom(Room room) {
        this.room = room;
    }

    public Format getFormat() {
        return format;
    }

    public void setFormat(Format format) {
        this.format = format;
    }

    public LocalDateTime getStartAt() {
        return startAt;
    }

    public void setStartAt(LocalDateTime startAt) {
        this.startAt = startAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public void setEndAt(LocalDateTime endAt) {
        this.endAt = endAt;
    }

    public String getSaleStatus() {
        return saleStatus;
    }

    public void setSaleStatus(String saleStatus) {
        this.saleStatus = saleStatus;
    }
}
