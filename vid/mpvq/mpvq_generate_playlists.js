const execSync = require("child_process").execSync;
const fs = require("fs");
const path = require("path");

// Retrieve MongoDB URI from pass
const MONGO_URI = execSync("pass mongo_mpvq", { encoding: "utf8" }).trim();

// MongoDB connection
const db = connect(MONGO_URI);
const playlistCollection = db.playlist;

// Directory to store playlists
const playlistDir = path.join(process.env.HOME, "Videos/playlists");

// Ensure the playlist directory exists
if (!fs.existsSync(playlistDir)) {
    fs.mkdirSync(playlistDir, { recursive: true });
}

// Function to format and write playlists
function exportPlaylists() {
    const playlists = playlistCollection.find().toArray();

    playlists.forEach(playlist => {
        const fileName = `${playlist.Name.replace(/[^a-zA-Z0-9_-]/g, "_")}.m3u`;
        const filePath = path.join(playlistDir, fileName);

        const content = playlist.Videos.map(video => {
            const metadata = [
                `#EXTINF:${video.Duration || -1},${video.Title || "Unknown Title"}`,
                video.URI,
            ];
            return metadata.join("\n");
        }).join("\n");

        fs.writeFileSync(filePath, content, "utf8");
        print(`Playlist "${playlist.Name}" exported to ${filePath}`);
    });
}

// Run the export
exportPlaylists();
print("All playlists exported successfully.");
