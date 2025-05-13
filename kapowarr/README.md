# Home Assistant Add-on: Kapowarr

**Searches for comics from various sources, grabs them, and sends them to a comic reader.**

## About

This add-on packages [Kapowarr](https://github.com/Casvt/Kapowarr), an application that helps you manage your digital comic book collection. It can:

*   Search various indexers for comic book releases.
*   Automatically grab new issues based on your wanted list.
*   Send downloaded comics to your preferred comic reader (e.g., Komga, Kavita, Ubooquity).
*   Manage metadata and notifications.

This add-on makes it easy to run Kapowarr directly within your Home Assistant Supervisor, providing a seamless experience.

## Installation

1.  **Add the Repository:**
    *   Navigate to the Supervisor panel in Home Assistant.
    *   Go to the "Add-on Store".
    *   Click the 3-dots menu in the top right and select "Repositories".
    *   Add the following URL:
        ```
        https://github.com/rigerc/ha-addons
        ```
    *   Close the dialog.

2.  **Install Kapowarr:**
    *   Refresh the Add-on Store page (Ctrl+R or Cmd+R).
    *   Find "Kapowarr" in the store (it might be under a section named after your repository).
    *   Click on "Kapowarr" and then click "INSTALL".
    *   Wait for the installation to complete.

## Configuration

Once installed, you'll need to configure the add-on before starting it.

```yaml
# Example Configuration:
download_path: /share/kapowarr_downloads # Default path for downloaded comics
comic_path: /share/Comics # Default path for downloaded comics
```