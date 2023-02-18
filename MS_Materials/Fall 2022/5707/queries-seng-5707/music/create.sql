CREATE TABLE Song(
  song_id VARCHAR2(10) primary key,
  song_title VARCHAR2(1000),
  artist VARCHAR2(1000),
  genre VARCHAR2(100),
  song_language VARCHAR2(10),
  duration NUMBER(3,2)
);

CREATE TABLE Artist(
  artist_id VARCHAR2(10) primary key,
  artist_name VARCHAR2(1000),
  region VARCHAR2(10)
);

CREATE TABLE SongStream(
  stream_id VARCHAR2(10) primary key,
  song_id VARCHAR2(10),
  URL VARCHAR2(1000),
  number_of_streams NUMBER(10),
  region VARCHAR2(10),
  stream_date VARCHAR2(50)
);

CREATE TABLE Region(
  region_id VARCHAR2(10) primary key,
  region_name VARCHAR2(100),
  native_language VARCHAR2(10)
);

CREATE TABLE LanguageMaster(
  language_id VARCHAR2(10) primary key,
  language_name VARCHAR2(100)
);

CREATE TABLE ServiceUser(
  user_id VARCHAR2(10) primary key,
  user_name VARCHAR2(200),
  native_language VARCHAR(10)
);

CREATE TABLE FavouriteSongs(
  user_id VARCHAR2(10),
  song_id VARCHAR2(10),
  date_added VARCHAR2(10)
);

CREATE TABLE Album(
  song_id VARCHAR2(10) primary key,
  artist_name VARCHAR2(1000),
  album_name VARCHAR2(1000)
);

ALTER TABLE FavouriteSongs ADD CONSTRAINT fav_song_pk primary key(user_id, song_id);