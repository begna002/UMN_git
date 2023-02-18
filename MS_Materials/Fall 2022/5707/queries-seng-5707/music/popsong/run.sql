-- Drop tables so they can be recreated again below. This speeds up the edit-rerun cycle.
-- You can also use the drop script to manually clean up later.
-- You will want to keep that script up to date cleaning up any relations added to this script.
-- Syntax notes: using "@@" invokes execution of another script, in a relative path to the current file, with inferred ".sql" at the end.
@@drop


SET SERVEROUTPUT ON
DECLARE
BEGIN

-- Group song streams over song_id to get "ID of song with its total number of streams"
ops.go(ops.group_ra('songstream','song_id','total_streams=sum(number_of_streams)','id_of_song_with_total_streams'));

-- Match Join all song data to get back "Song with its total number of streams"
ops.go(ops.mjoin_ra('song','id_of_song_with_total_streams','song_id','song_id','song_with_total_streams'));

-- Group by genre to get "Genre with (number of streams for its most-streamed song) data"
ops.go(ops.group_ra('song_with_total_streams','genre','max_streams=max(total_streams)','genre_with_max_total_streams'));

-- Times, Filter, Reduce to get the most popular song per genre.
-- Can this also be a Match Join?
-- Is the Reduce dangerous?
ops.go(ops.times_ra('S=song_with_total_streams','G=genre_with_max_total_streams','song__genre_max_pair'));
ops.go(ops.filter_ra('song__genre_max_pair','total_streams=max_streams','pop_song__genre_max_pair'));
ops.go(ops.reduce_ra('pop_song__genre_max_pair','song_id','genre=G_genre,song_title','pop_song_of_genre'));

END;
/

select * from pop_song_of_genre;
