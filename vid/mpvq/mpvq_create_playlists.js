/* Required modules */
const { writeFileSync, mkdirSync } = require("fs");
const { resolve } = require("path");
const HOME_DIR = process.env.HOME || process.env.USERPROFILE;
const PLAYLISTS_DIR = resolve(HOME_DIR, "Videos", "yt", "playlists");

/* Ensure playlists directory exists */
mkdirSync(PLAYLISTS_DIR, { recursive: true });

/* Retrieve MongoDB URI */
const execSync = require("child_process").execSync;
const MONGO_URI = execSync("pass mongo_mpvq", { encoding: "utf8" }).trim();

/* Connect to MongoDB */
const db = connect(MONGO_URI);
const sourceCollection = db.yt;
const targetCollection = db.playlist;

/* Helper to create and export a playlist entry */
function createAndExportPlaylist(name, videos) {
  if (videos.length === 0) return;

  // Insert into MongoDB target collection
  targetCollection.updateOne(
    { Name: name },
    { $set: { Name: name, Videos: videos } },
    { upsert: true }
  );

  // Write playlist to JSON file
  const playlistFile = resolve(PLAYLISTS_DIR, `${sanitizeFilename(name)}.json`);
  writeFileSync(playlistFile, JSON.stringify(videos, null, 2));
  print(`Exported playlist: ${playlistFile}`);
}

/* Safely extract metadata with defaults and include description */
function extractMetadata(video) {
  const metadata = video.Metadata || {};
  return {
    Title: metadata.Title || "Unknown Title",
    URI: metadata.OriginalURL || "Unknown URI",
    Description: metadata.Description || "No description available.",
    Duration: metadata.DurationString || "Unknown Duration",
    Resolution: metadata.Resolution || "Unknown Resolution",
    UploadDate: metadata.UploadDate || "Unknown Date",
    Playlist: metadata.Playlist || "No Playlist",
    LikeCount: metadata.LikeCount || 0,
    CommentCount: metadata.CommentCount || 0,
  };
}

/* Sanitize filenames for export */
function sanitizeFilename(name) {
  return name.replace(/[<>:"/\\|?*]+/g, "_").replace(/\s+/g, "_").toLowerCase();
}

/* Playlist generation functions */
function createUploaderPlaylists() {
  const uploaders = sourceCollection.distinct("Uploader");
  uploaders.forEach(uploader => {
    const videos = sourceCollection
      .find({ Uploader: uploader })
      .sort({ "Metadata.Timestamp": 1 }) // Sort by upload time (oldest first)
      .map(video => extractMetadata(video)) // Safely extract metadata
      .toArray();
    createAndExportPlaylist(`${uploader} - Chronological`, videos);
  });
}

function createPopularityPlaylists() {
  const videos = sourceCollection
    .aggregate([
      {
        $addFields: {
          PopularityScore: {
            $add: ["$Metadata.LikeCount", { $multiply: ["$Metadata.CommentCount", 2] }],
          },
        },
      },
      { $sort: { PopularityScore: -1 } }, // Sort by descending popularity
    ])
    .map(video => extractMetadata(video)) // Safely extract metadata
    .toArray();
  createAndExportPlaylist("Most Popular Videos", videos);
}

function createDurationPlaylists() {
  const videos = sourceCollection
    .find()
    .sort({ "Metadata.Duration": 1 }) // Shortest to longest
    .map(video => extractMetadata(video)) // Safely extract metadata
    .toArray();
  createAndExportPlaylist("Videos by Duration", videos);
}

function createUploaderSubcategories() {
  const uploaders = sourceCollection.distinct("Uploader");
  uploaders.forEach(uploader => {
    const videosByDuration = sourceCollection
      .find({ Uploader: uploader })
      .sort({ "Metadata.Duration": 1 })
      .map(video => extractMetadata(video)) // Safely extract metadata
      .toArray();
    createAndExportPlaylist(`${uploader} - Shortest to Longest`, videosByDuration);

    const videosByPopularity = sourceCollection
      .aggregate([
        { $match: { Uploader: uploader } },
        {
          $addFields: {
            PopularityScore: {
              $add: ["$Metadata.LikeCount", { $multiply: ["$Metadata.CommentCount", 2] }],
            },
          },
        },
        { $sort: { PopularityScore: -1 } },
      ])
      .map(video => extractMetadata(video)) // Safely extract metadata
      .toArray();
    createAndExportPlaylist(`${uploader} - Most Popular`, videosByPopularity);
  });
}

/* Generate playlists */
function generatePlaylists() {
  createUploaderPlaylists();
  createPopularityPlaylists();
  createDurationPlaylists();
  createUploaderSubcategories();
  print("Playlists created and exported successfully.");
}

/* MPV and Dunst integration helper script */
function generateMpvNotificationScript() {
  const scriptContent = `
#!/bin/sh
# Notify MPV with video title and description
notify-send "Now Playing: $1" "$2" --icon=video-x-generic
`;
  const scriptPath = resolve(HOME_DIR, "Scripts", "mpv_notify.sh");
  mkdirSync(resolve(HOME_DIR, "Scripts"), { recursive: true });
  writeFileSync(scriptPath, scriptContent, { mode: 0o755 });
  print(`MPV notification script created at: ${scriptPath}`);
}

/* Run all tasks */
generatePlaylists();
generateMpvNotificationScript();
