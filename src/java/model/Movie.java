
package model;

import java.time.LocalDate;

public class Movie {

    private int id;
    private String movieTitle;
    private int duration;
    private String description;
    private String director;
    private String actor;
    private String ageRating;
    private LocalDate releaseDate;
    private String poster;
    private boolean nowShowing;

    public Movie() {
    }

    public Movie(int id, String movieTitle, int duration,
                 String description, String director, String actor,
                 String ageRating, LocalDate releaseDate,
                 String poster, boolean nowShowing) {

        this.id = id;
        this.movieTitle = movieTitle;
        this.duration = duration;
        this.description = description;
        this.director = director;
        this.actor = actor;
        this.ageRating = ageRating;
        this.releaseDate = releaseDate;
        this.poster = poster;
        this.nowShowing = nowShowing;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getActor() {
        return actor;
    }

    public void setActor(String actor) {
        this.actor = actor;
    }

    public String getAgeRating() {
        return ageRating;
    }

    public void setAgeRating(String ageRating) {
        this.ageRating = ageRating;
    }

    public LocalDate getReleaseDate() {
        return releaseDate;
    }

    public void setReleaseDate(LocalDate releaseDate) {
        this.releaseDate = releaseDate;
    }

    public String getPoster() {
        return poster;
    }

    public void setPoster(String poster) {
        this.poster = poster;
    }

    public boolean isNowShowing() {
        return nowShowing;
    }

    public void setNowShowing(boolean nowShowing) {
        this.nowShowing = nowShowing;
    }
}
