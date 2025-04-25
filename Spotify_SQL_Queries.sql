-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

--EDA

SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) FROM spotify;

SELECT DISTINCT album_type from spotify;

SELECT MAX(duration_min) from spotify;

SELECT MIN(duration_min) from spotify;

SELECT * from spotify
WHERE duration_min = 0;

DELETE from spotify
WHERE duration_min = 0;

SELECT COUNT(DISTINCT channel) FROM spotify;

SELECT DISTINCT most_played_on FROM spotify;

--Problems:

--1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify
WHERE stream > 1000000000;

--2. List all albums along with their respective artists.

SELECT DISTINCT album,artist FROM spotify;

--3. Get the total number of comments for tracks where licensed = TRUE.

SELECT SUM(comments) as Total_comments
FROM spotify
WHERE licensed = TRUE;

--4. Find all tracks that belong to the album type single.

SELECT * FROM spotify;

SELECT * FROM spotify
WHERE album_type = 'single';

--5. Count the total number of tracks by each artist.

SELECT artist,COUNT(track) AS Total_number_of_tracks
FROM spotify
GROUP BY artist;

--6. Calculate the average danceability of tracks in each album.

SELECT album,AVG(danceability) AS Average_Danceability
FROM spotify
GROUP BY album;

--7. Find the top 5 tracks with the highest energy values.

SELECT * FROM spotify;

SELECT track,MAX(energy) FROM spotify
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--8. List all tracks along with their views and likes where official_video = TRUE.

SELECT track,
	SUM(views) AS total_views, SUM(likes) AS total_likes 
FROM spotify
WHERE official_video = TRUE
GROUP BY 1
ORDER BY 2 DESC;

--9. For each album, calculate the total views of all associated tracks.

SELECT album,track,SUM(views) AS total_views
FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;

--10. Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM 
(SELECT track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) AS streamed_on_spotify,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS streamed_on_youtube
FROM Spotify
GROUP BY 1) AS T1
WHERE streamed_on_spotify > streamed_on_youtube
AND streamed_on_youtube <> 0;

--11. Find the top 3 most-viewed tracks for each artist using window functions.

SELECT * FROM spotify;

WITH ranking_artist AS
(SELECT artist,
	   track,
	   SUM(views) AS total_view,
	   DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM Spotify
GROUP BY 1,2
ORDER BY 1,3 DESC)
SELECT * FROM ranking_artist
WHERE rank <= 3;

--12. Write a query to find tracks where the liveness score is above the average.

SELECT artist,track,liveness
FROM Spotify
WHERE liveness > (SELECT AVG(liveness) FROM Spotify);

--13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

SELECT * FROM spotify;

WITH CTE AS
(
SELECT album,
	   MAX(energy) AS highest_energy,
	   MIN(energy) AS lowest_energy
FROM Spotify
GROUP BY 1
)
SELECT album,
	   highest_energy - lowest_energy AS energy_diff
FROM CTE
ORDER BY 2 DESC;


--Query Optimization:

EXPLAIN ANALYZE 
SELECT artist,track,views
FROM Spotify
WHERE artist = 'Gorillaz' AND most_played_on = 'Youtube'
ORDER BY stream DESC 
LIMIT 25

CREATE INDEX artist_index ON Spotify (artist);





















