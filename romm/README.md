# Romm Home Assistant Add-on

**A beautiful, powerful, self-hosted ROM manager now available as a Home Assistant Add-on.**

This add-on packages [Romm](https://github.com/rommapp/romm) for easy installation and use within your Home Assistant environment.

## About Romm

Romm is a self-hosted application designed to manage your retro game ROM collection. It allows you to scan, enrich, browse, and even play your games through a clean and responsive web interface.

Key features of Romm include:

* **Metadata Enrichment:** Automatically scans your game library and fetches detailed metadata, cover art, and other information from databases like IGDB, Screenscraper, and MobyGames.
* **Broad Platform Support:** Supports a vast number of gaming consoles and platforms, both retro and modern (400+ systems).
* **Web-Based Gameplay:** Integrates with EmulatorJS, allowing you to play many of your favorite games directly in your web browser.
* **Organize Your Collection:** Offers robust tagging, filtering, and search capabilities to manage your ROMs effectively. Supports multi-disk games, DLCs, mods, patches, and manuals.
* **User Management:** Share your library with friends with options for limited access and permissions.
* **Modern Interface:** View, upload, update, and delete games from any modern web browser.
* **Open Source:** Built by the community, for the community, and licensed under AGPL-3.0.

For more detailed information about Romm, please visit the official Romm GitHub repository: [https://github.com/rommapp/romm](https://github.com/rommapp/romm)

## Prerequisites

**IMPORTANT: This add-on requires the official Home Assistant MariaDB add-on to be installed and properly configured.**

Romm uses a SQL database to store its data, and this add-on is designed to integrate with the official MariaDB add-on.

## Installation

1.  **Add the Repository:**
    * Navigate to **Settings > Add-ons > Add-on Store**.
    * Click the three dots in the top right corner and select **Repositories**.
    * Add the URL of this add-on's repository and click **Add**.
2.  **Install the Romm Add-on:**
    * Refresh the Add-on Store page.
    * Search for "Romm" and click on the add-on.
    * Click **Install** and wait for the installation to complete.

## Configuration

Once the Romm add-on is installed, you will need to configure it with the MariaDB database details you set up earlier.