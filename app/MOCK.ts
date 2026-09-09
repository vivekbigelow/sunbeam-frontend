type Song = {
  id: string;
  title: string;
  artist: string;
  album: string;
  releaseDate: string;
  createdAt: string;
  updatedAt: string;
};

type Album = {
  id: string;
  title: string;
  songs: string[];
  artists: string[];
  releaseDate: string;
  createdAt: string;
  updatedAt: string;
};

type Artist = {
  id: string;
  name: string;
  albums: string[];
  songs: string[];
  createdAt: string;
  updatedAt: string;
};

type Playlist = {
  id: string;
  title: string;
  songs: string[];
  createdAt: string;
  updatedAt: string;
};

export let SONGS: Song[] = [
  {
    id: "1",
    title: "Helen",
    artist: "Ariel Pink",
    album: "House Arrest",
    releaseDate: "2002",
    createdAt: "2026-09-08",
    updatedAt: "2026-09-08",
  },
];

export const ALBUMS: Album[] = [
  {
    id: "1",
    title: "House Arrest",
    songs: ["Helen"],
    artists: ["Ariel Pink"],
    releaseDate: "2002",
    createdAt: "2026-09-08",
    updatedAt: "2026-09-08",
  },
];

export const ARTISTS: Artist[] = [
  {
    id: "1",
    name: "Ariel Pink",
    songs: ["Helen"],
    albums: ["House Arrest"],
    createdAt: "2026-09-08",
    updatedAt: "2026-09-08",
  },
];

export const PLAYLISTS: Playlist[] = [
  {
    id: "1",
    title: "Weirdo Rock",
    songs: ["Helen"],
    createdAt: "2026-09-08",
    updatedAt: "2026-09-08",
  },
];

export async function getSongs(): Promise<Song[]> {
  return [...SONGS];
}

export function addSong(song: Song) {
  SONGS = [...SONGS, song];
  console.log("Songs updated", SONGS);
}
