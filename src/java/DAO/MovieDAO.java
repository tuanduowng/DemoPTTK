package dao;

import model.Movie;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO extends DAO {

    public MovieDAO() throws SQLException {
        super();
    }

    public List<Movie> getMovieList(String keyword) throws SQLException {

        List<Movie> movies = new ArrayList<>();

        String sql = "SELECT * FROM tblmovie "
                + "WHERE movieTitle LIKE ? "
                + "ORDER BY movieTitle";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword.trim() + "%");

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Movie movie = new Movie();

                    movie.setId(rs.getInt("id"));
                    movie.setMovieTitle(rs.getString("movieTitle"));
                    movie.setDuration(rs.getInt("duration"));
                    movie.setDescription(rs.getString("description"));
                    movie.setDirector(rs.getString("director"));
                    movie.setActor(rs.getString("actor"));
                    movie.setAgeRating(rs.getString("ageRating"));

                    if (rs.getDate("releaseDate") != null) {
                        movie.setReleaseDate(
                                rs.getDate("releaseDate").toLocalDate()
                        );
                    }

                    movie.setPoster(rs.getString("poster"));
                    movie.setNowShowing(rs.getBoolean("nowShowing"));

                    movies.add(movie);
                }
            }
        }

        return movies;
    }

}
