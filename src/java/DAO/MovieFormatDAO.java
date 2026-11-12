
package dao;

import model.Movie;
import model.Format;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MovieFormatDAO extends DAO {

    public MovieFormatDAO() throws SQLException {
        super();
    }

    // Lấy danh sách phim đang được chiếu
    public List<Movie> getAllMovies() throws SQLException {

        List<Movie> movies = new ArrayList<>();

        String sql = """
                SELECT *
                FROM tblMovie
                WHERE nowShowing = TRUE
                ORDER BY movieTitle
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

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

        return movies;
    }

    // Lấy thông tin phim theo ID
    public Movie getMovieById(int movieId) throws SQLException {

        String sql = """
                SELECT *
                FROM tblMovie
                WHERE id = ?
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

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

                    return movie;
                }
            }
        }

        return null;
    }

    // Lấy các định dạng mà phim hỗ trợ
    public List<Format> getFormatsByMovieId(int movieId)
            throws SQLException {

        List<Format> formats = new ArrayList<>();

        String sql = """
                SELECT f.id, f.formatName, f.description
                FROM tblFormat f
                JOIN tblMovieFormat mf
                    ON f.id = mf.tblFormatid
                WHERE mf.tblMovieid = ?
                ORDER BY f.formatName
                """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Format format = new Format();

                    format.setId(rs.getInt("id"));
                    format.setFormatName(rs.getString("formatName"));
                    format.setDescription(rs.getString("description"));

                    formats.add(format);
                }
            }
        }

        return formats;
    }
}
