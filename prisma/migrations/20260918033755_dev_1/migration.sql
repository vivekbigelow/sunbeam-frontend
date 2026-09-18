/*
  Warnings:

  - You are about to drop the `Genre` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Playlist` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `Tag` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_GenreToSong` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_PlaylistToSong` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_SongToTag` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `albums` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `songs` table. If the table is not empty, all the data it contains will be lost.

*/
-- CreateEnum
CREATE TYPE "ReleaseType" AS ENUM ('ALBUM', 'EP', 'SINGLE', 'COMPILATION', 'LIVE', 'DEMO', 'BOOTLEG', 'MIXTAPE', 'SOUNDTRACK', 'REMIX', 'REISSUE', 'REMASTER', 'BOX_SET', 'OTHER');

-- CreateEnum
CREATE TYPE "ArtistRole" AS ENUM ('PRIMARY', 'FEATURED', 'REMIXER', 'COMPOSER', 'DJ', 'OTHER');

-- CreateEnum
CREATE TYPE "CreditRole" AS ENUM ('PRODUCER', 'EXECUTIVE_PRODUCER', 'ENGINEER', 'MIXING', 'MASTERING', 'DESIGN', 'PHOTOGRAPHY', 'LYRICIST', 'COMPOSER', 'SONGWRITER', 'OTHER');

-- CreateEnum
CREATE TYPE "LocationType" AS ENUM ('FROM', 'FORMED_IN', 'BASED_IN', 'ASSOCIATED_WITH');

-- CreateEnum
CREATE TYPE "SceneRole" AS ENUM ('MEMBER', 'ASSOCIATED', 'INFLUENTIAL', 'ORIGINATED');

-- CreateEnum
CREATE TYPE "CollectionStatus" AS ENUM ('OWNED', 'WANTED', 'PREVIOUSLY_OWNED', 'CONTRIBUTED');

-- DropForeignKey
ALTER TABLE "Playlist" DROP CONSTRAINT "Playlist_author_id_fkey";

-- DropForeignKey
ALTER TABLE "_GenreToSong" DROP CONSTRAINT "_GenreToSong_A_fkey";

-- DropForeignKey
ALTER TABLE "_GenreToSong" DROP CONSTRAINT "_GenreToSong_B_fkey";

-- DropForeignKey
ALTER TABLE "_PlaylistToSong" DROP CONSTRAINT "_PlaylistToSong_A_fkey";

-- DropForeignKey
ALTER TABLE "_PlaylistToSong" DROP CONSTRAINT "_PlaylistToSong_B_fkey";

-- DropForeignKey
ALTER TABLE "_SongToTag" DROP CONSTRAINT "_SongToTag_A_fkey";

-- DropForeignKey
ALTER TABLE "_SongToTag" DROP CONSTRAINT "_SongToTag_B_fkey";

-- DropForeignKey
ALTER TABLE "albums" DROP CONSTRAINT "albums_artist_id_fkey";

-- DropForeignKey
ALTER TABLE "songs" DROP CONSTRAINT "songs_album_id_fkey";

-- DropForeignKey
ALTER TABLE "songs" DROP CONSTRAINT "songs_artist_id_fkey";

-- DropForeignKey
ALTER TABLE "songs" DROP CONSTRAINT "songs_author_id_fkey";

-- AlterTable
ALTER TABLE "artists" ADD COLUMN     "bio" VARCHAR(500),
ADD COLUMN     "image_url" TEXT,
ALTER COLUMN "name" SET DATA TYPE VARCHAR(200);

-- AlterTable
ALTER TABLE "users" ADD COLUMN     "avatar_url" TEXT,
ADD COLUMN     "bio" VARCHAR(500),
ADD COLUMN     "display_name" TEXT;

-- DropTable
DROP TABLE "Genre";

-- DropTable
DROP TABLE "Playlist";

-- DropTable
DROP TABLE "Tag";

-- DropTable
DROP TABLE "_GenreToSong";

-- DropTable
DROP TABLE "_PlaylistToSong";

-- DropTable
DROP TABLE "_SongToTag";

-- DropTable
DROP TABLE "albums";

-- DropTable
DROP TABLE "songs";

-- CreateTable
CREATE TABLE "artist_aliases" (
    "id" SERIAL NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "artist_aliases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "locations" (
    "id" SERIAL NOT NULL,
    "city" VARCHAR(100),
    "region" VARCHAR(100),
    "country" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "artist_locations" (
    "id" SERIAL NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "location_id" INTEGER NOT NULL,
    "type" "LocationType" NOT NULL DEFAULT 'FORMED_IN',

    CONSTRAINT "artist_locations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "scenes" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "description" VARCHAR(500),
    "location_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "scenes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "artist_scenes" (
    "id" SERIAL NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "scene_id" INTEGER NOT NULL,
    "role" "SceneRole" NOT NULL DEFAULT 'ASSOCIATED',

    CONSTRAINT "artist_scenes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "labels" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "website_url" TEXT,
    "image_url" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "labels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "releases" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(200) NOT NULL,
    "releaseType" "ReleaseType" NOT NULL DEFAULT 'ALBUM',
    "release_date" TIMESTAMP(3),
    "location_id" INTEGER,
    "language" VARCHAR(100),
    "description" TEXT,
    "cover_art_url" TEXT,
    "catalog_number" VARCHAR(100),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "releases_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "release_artists" (
    "id" SERIAL NOT NULL,
    "release_id" INTEGER NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "role" "ArtistRole" NOT NULL DEFAULT 'PRIMARY',

    CONSTRAINT "release_artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "release_labels" (
    "id" SERIAL NOT NULL,
    "release_id" INTEGER NOT NULL,
    "label_id" INTEGER NOT NULL,

    CONSTRAINT "release_labels_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recordings" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "duration_seconds" INTEGER,
    "version_name" VARCHAR(255),
    "lyrics" TEXT,
    "language" VARCHAR(100),
    "audio_file_key" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "recordings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recording_artists" (
    "id" SERIAL NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "role" "ArtistRole" NOT NULL DEFAULT 'PRIMARY',

    CONSTRAINT "recording_artists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "release_tracks" (
    "id" SERIAL NOT NULL,
    "release_id" INTEGER NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "track_number" INTEGER NOT NULL,

    CONSTRAINT "release_tracks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "genres" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "parent_id" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "genres_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "release_genres" (
    "id" SERIAL NOT NULL,
    "release_id" INTEGER NOT NULL,
    "genre_id" INTEGER NOT NULL,

    CONSTRAINT "release_genres_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recording_genres" (
    "id" SERIAL NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "genre_id" INTEGER NOT NULL,

    CONSTRAINT "recording_genres_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "descriptors" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "descriptors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "release_descriptors" (
    "id" SERIAL NOT NULL,
    "release_id" INTEGER NOT NULL,
    "descriptor_id" INTEGER NOT NULL,

    CONSTRAINT "release_descriptors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recording_descriptors" (
    "id" SERIAL NOT NULL,
    "song_id" INTEGER NOT NULL,
    "descriptor_id" INTEGER NOT NULL,

    CONSTRAINT "recording_descriptors_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "credits" (
    "id" SERIAL NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "artist_id" INTEGER NOT NULL,
    "role" "CreditRole" NOT NULL,
    "instrument" VARCHAR(100),

    CONSTRAINT "credits_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ratings" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "release_id" INTEGER NOT NULL,
    "rating" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ratings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "reviews" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "release_id" INTEGER NOT NULL,
    "title" VARCHAR(255),
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "comments" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "review_id" INTEGER NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "comments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "follows" (
    "id" SERIAL NOT NULL,
    "follower_id" INTEGER NOT NULL,
    "following_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "follows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "playlists" (
    "id" SERIAL NOT NULL,
    "title" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "author_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "playlists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "playlist_songs" (
    "id" SERIAL NOT NULL,
    "playlist_id" INTEGER NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "position" INTEGER NOT NULL,

    CONSTRAINT "playlist_songs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "listening_history" (
    "id" SERIAL NOT NULL,
    "user_id" INTEGER NOT NULL,
    "recording_id" INTEGER NOT NULL,
    "played_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "duration_played_seconds" INTEGER,

    CONSTRAINT "listening_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recommendations" (
    "id" SERIAL NOT NULL,
    "from_user_id" INTEGER NOT NULL,
    "to_user_id" INTEGER NOT NULL,
    "release_id" INTEGER,
    "recording_id" INTEGER,
    "message" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "read_at" TIMESTAMP(3),

    CONSTRAINT "recommendations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "artist_aliases_name_idx" ON "artist_aliases"("name");

-- CreateIndex
CREATE INDEX "artist_aliases_artist_id_idx" ON "artist_aliases"("artist_id");

-- CreateIndex
CREATE INDEX "artist_locations_artist_id_idx" ON "artist_locations"("artist_id");

-- CreateIndex
CREATE INDEX "artist_locations_location_id_idx" ON "artist_locations"("location_id");

-- CreateIndex
CREATE UNIQUE INDEX "artist_locations_artist_id_location_id_type_key" ON "artist_locations"("artist_id", "location_id", "type");

-- CreateIndex
CREATE INDEX "scenes_name_idx" ON "scenes"("name");

-- CreateIndex
CREATE INDEX "scenes_location_id_idx" ON "scenes"("location_id");

-- CreateIndex
CREATE INDEX "artist_scenes_artist_id_idx" ON "artist_scenes"("artist_id");

-- CreateIndex
CREATE INDEX "artist_scenes_scene_id_idx" ON "artist_scenes"("scene_id");

-- CreateIndex
CREATE UNIQUE INDEX "artist_scenes_artist_id_scene_id_key" ON "artist_scenes"("artist_id", "scene_id");

-- CreateIndex
CREATE UNIQUE INDEX "labels_name_key" ON "labels"("name");

-- CreateIndex
CREATE INDEX "labels_name_idx" ON "labels"("name");

-- CreateIndex
CREATE INDEX "releases_title_idx" ON "releases"("title");

-- CreateIndex
CREATE INDEX "releases_release_date_idx" ON "releases"("release_date");

-- CreateIndex
CREATE INDEX "releases_releaseType_idx" ON "releases"("releaseType");

-- CreateIndex
CREATE INDEX "release_artists_release_id_idx" ON "release_artists"("release_id");

-- CreateIndex
CREATE INDEX "release_artists_artist_id_idx" ON "release_artists"("artist_id");

-- CreateIndex
CREATE UNIQUE INDEX "release_artists_release_id_artist_id_role_key" ON "release_artists"("release_id", "artist_id", "role");

-- CreateIndex
CREATE INDEX "release_labels_release_id_idx" ON "release_labels"("release_id");

-- CreateIndex
CREATE INDEX "release_labels_label_id_idx" ON "release_labels"("label_id");

-- CreateIndex
CREATE UNIQUE INDEX "release_labels_release_id_label_id_key" ON "release_labels"("release_id", "label_id");

-- CreateIndex
CREATE INDEX "recordings_title_idx" ON "recordings"("title");

-- CreateIndex
CREATE INDEX "recording_artists_recording_id_idx" ON "recording_artists"("recording_id");

-- CreateIndex
CREATE INDEX "recording_artists_artist_id_idx" ON "recording_artists"("artist_id");

-- CreateIndex
CREATE UNIQUE INDEX "recording_artists_recording_id_artist_id_role_key" ON "recording_artists"("recording_id", "artist_id", "role");

-- CreateIndex
CREATE INDEX "release_tracks_release_id_idx" ON "release_tracks"("release_id");

-- CreateIndex
CREATE INDEX "release_tracks_recording_id_idx" ON "release_tracks"("recording_id");

-- CreateIndex
CREATE UNIQUE INDEX "release_tracks_release_id_track_number_key" ON "release_tracks"("release_id", "track_number");

-- CreateIndex
CREATE UNIQUE INDEX "genres_name_key" ON "genres"("name");

-- CreateIndex
CREATE INDEX "genres_name_idx" ON "genres"("name");

-- CreateIndex
CREATE INDEX "genres_parent_id_idx" ON "genres"("parent_id");

-- CreateIndex
CREATE INDEX "release_genres_release_id_idx" ON "release_genres"("release_id");

-- CreateIndex
CREATE INDEX "release_genres_genre_id_idx" ON "release_genres"("genre_id");

-- CreateIndex
CREATE UNIQUE INDEX "release_genres_release_id_genre_id_key" ON "release_genres"("release_id", "genre_id");

-- CreateIndex
CREATE INDEX "recording_genres_recording_id_idx" ON "recording_genres"("recording_id");

-- CreateIndex
CREATE INDEX "recording_genres_genre_id_idx" ON "recording_genres"("genre_id");

-- CreateIndex
CREATE UNIQUE INDEX "recording_genres_recording_id_genre_id_key" ON "recording_genres"("recording_id", "genre_id");

-- CreateIndex
CREATE UNIQUE INDEX "descriptors_name_key" ON "descriptors"("name");

-- CreateIndex
CREATE INDEX "descriptors_name_idx" ON "descriptors"("name");

-- CreateIndex
CREATE INDEX "release_descriptors_release_id_idx" ON "release_descriptors"("release_id");

-- CreateIndex
CREATE INDEX "release_descriptors_descriptor_id_idx" ON "release_descriptors"("descriptor_id");

-- CreateIndex
CREATE UNIQUE INDEX "release_descriptors_release_id_descriptor_id_key" ON "release_descriptors"("release_id", "descriptor_id");

-- CreateIndex
CREATE INDEX "recording_descriptors_song_id_idx" ON "recording_descriptors"("song_id");

-- CreateIndex
CREATE INDEX "recording_descriptors_descriptor_id_idx" ON "recording_descriptors"("descriptor_id");

-- CreateIndex
CREATE UNIQUE INDEX "recording_descriptors_song_id_descriptor_id_key" ON "recording_descriptors"("song_id", "descriptor_id");

-- CreateIndex
CREATE INDEX "credits_recording_id_idx" ON "credits"("recording_id");

-- CreateIndex
CREATE INDEX "credits_artist_id_idx" ON "credits"("artist_id");

-- CreateIndex
CREATE INDEX "ratings_release_id_idx" ON "ratings"("release_id");

-- CreateIndex
CREATE INDEX "ratings_user_id_idx" ON "ratings"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "ratings_user_id_release_id_key" ON "ratings"("user_id", "release_id");

-- CreateIndex
CREATE INDEX "reviews_user_id_idx" ON "reviews"("user_id");

-- CreateIndex
CREATE INDEX "reviews_release_id_idx" ON "reviews"("release_id");

-- CreateIndex
CREATE INDEX "comments_review_id_idx" ON "comments"("review_id");

-- CreateIndex
CREATE INDEX "comments_user_id_idx" ON "comments"("user_id");

-- CreateIndex
CREATE INDEX "follows_follower_id_idx" ON "follows"("follower_id");

-- CreateIndex
CREATE INDEX "follows_following_id_idx" ON "follows"("following_id");

-- CreateIndex
CREATE UNIQUE INDEX "follows_follower_id_following_id_key" ON "follows"("follower_id", "following_id");

-- CreateIndex
CREATE INDEX "playlists_author_id_idx" ON "playlists"("author_id");

-- CreateIndex
CREATE INDEX "playlist_songs_playlist_id_idx" ON "playlist_songs"("playlist_id");

-- CreateIndex
CREATE INDEX "playlist_songs_recording_id_idx" ON "playlist_songs"("recording_id");

-- CreateIndex
CREATE UNIQUE INDEX "playlist_songs_playlist_id_position_key" ON "playlist_songs"("playlist_id", "position");

-- CreateIndex
CREATE INDEX "listening_history_user_id_played_at_idx" ON "listening_history"("user_id", "played_at");

-- CreateIndex
CREATE INDEX "listening_history_recording_id_idx" ON "listening_history"("recording_id");

-- CreateIndex
CREATE INDEX "listening_history_played_at_idx" ON "listening_history"("played_at");

-- CreateIndex
CREATE INDEX "recommendations_from_user_id_idx" ON "recommendations"("from_user_id");

-- CreateIndex
CREATE INDEX "recommendations_to_user_id_idx" ON "recommendations"("to_user_id");

-- CreateIndex
CREATE INDEX "recommendations_created_at_idx" ON "recommendations"("created_at");

-- CreateIndex
CREATE INDEX "recommendations_release_id_idx" ON "recommendations"("release_id");

-- CreateIndex
CREATE INDEX "recommendations_recording_id_idx" ON "recommendations"("recording_id");

-- CreateIndex
CREATE INDEX "artists_name_idx" ON "artists"("name");

-- CreateIndex
CREATE INDEX "users_username_idx" ON "users"("username");

-- AddForeignKey
ALTER TABLE "artist_aliases" ADD CONSTRAINT "artist_aliases_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "artist_locations" ADD CONSTRAINT "artist_locations_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "artist_locations" ADD CONSTRAINT "artist_locations_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "scenes" ADD CONSTRAINT "scenes_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "artist_scenes" ADD CONSTRAINT "artist_scenes_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "artist_scenes" ADD CONSTRAINT "artist_scenes_scene_id_fkey" FOREIGN KEY ("scene_id") REFERENCES "scenes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "releases" ADD CONSTRAINT "releases_location_id_fkey" FOREIGN KEY ("location_id") REFERENCES "locations"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_artists" ADD CONSTRAINT "release_artists_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_artists" ADD CONSTRAINT "release_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_labels" ADD CONSTRAINT "release_labels_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_labels" ADD CONSTRAINT "release_labels_label_id_fkey" FOREIGN KEY ("label_id") REFERENCES "labels"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recordings" ADD CONSTRAINT "recordings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_artists" ADD CONSTRAINT "recording_artists_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_artists" ADD CONSTRAINT "recording_artists_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_tracks" ADD CONSTRAINT "release_tracks_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_tracks" ADD CONSTRAINT "release_tracks_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "genres" ADD CONSTRAINT "genres_parent_id_fkey" FOREIGN KEY ("parent_id") REFERENCES "genres"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_genres" ADD CONSTRAINT "release_genres_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_genres" ADD CONSTRAINT "release_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genres"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_genres" ADD CONSTRAINT "recording_genres_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_genres" ADD CONSTRAINT "recording_genres_genre_id_fkey" FOREIGN KEY ("genre_id") REFERENCES "genres"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_descriptors" ADD CONSTRAINT "release_descriptors_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "release_descriptors" ADD CONSTRAINT "release_descriptors_descriptor_id_fkey" FOREIGN KEY ("descriptor_id") REFERENCES "descriptors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_descriptors" ADD CONSTRAINT "recording_descriptors_song_id_fkey" FOREIGN KEY ("song_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recording_descriptors" ADD CONSTRAINT "recording_descriptors_descriptor_id_fkey" FOREIGN KEY ("descriptor_id") REFERENCES "descriptors"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credits" ADD CONSTRAINT "credits_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "credits" ADD CONSTRAINT "credits_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "artists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratings" ADD CONSTRAINT "ratings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ratings" ADD CONSTRAINT "ratings_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "reviews" ADD CONSTRAINT "reviews_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "comments" ADD CONSTRAINT "comments_review_id_fkey" FOREIGN KEY ("review_id") REFERENCES "reviews"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "follows" ADD CONSTRAINT "follows_follower_id_fkey" FOREIGN KEY ("follower_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "follows" ADD CONSTRAINT "follows_following_id_fkey" FOREIGN KEY ("following_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "playlists" ADD CONSTRAINT "playlists_author_id_fkey" FOREIGN KEY ("author_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "playlist_songs" ADD CONSTRAINT "playlist_songs_playlist_id_fkey" FOREIGN KEY ("playlist_id") REFERENCES "playlists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "playlist_songs" ADD CONSTRAINT "playlist_songs_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "listening_history" ADD CONSTRAINT "listening_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "listening_history" ADD CONSTRAINT "listening_history_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendations" ADD CONSTRAINT "recommendations_from_user_id_fkey" FOREIGN KEY ("from_user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendations" ADD CONSTRAINT "recommendations_to_user_id_fkey" FOREIGN KEY ("to_user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendations" ADD CONSTRAINT "recommendations_release_id_fkey" FOREIGN KEY ("release_id") REFERENCES "releases"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recommendations" ADD CONSTRAINT "recommendations_recording_id_fkey" FOREIGN KEY ("recording_id") REFERENCES "recordings"("id") ON DELETE CASCADE ON UPDATE CASCADE;
