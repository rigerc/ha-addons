# 🏠 Home Assistant Addons: rigerc's addons

Welcome to rigerc's collection of Home Assistant Addons! 🌟

## ℹ️ About This Repository

This repository contains a collection of Home Assistant addons developed by **rigerc**.

**⚠️ Important Notes:**
* These addons are designed for Home Assistant.
* Please ensure your Home Assistant Supervisor is up to date before installing any addons from this repository.
* These addons are provided as-is. While I strive to maintain them, use them at your own risk.

## 🛠️ How to Add This Repository to Home Assistant

You can add this repository to your Home Assistant instance by following these steps:

1.  **Navigate to your Home Assistant Add-on Store:**
    * In your Home Assistant UI, go to `Settings` > `Add-ons`.
    * Click on the `ADD-ON STORE` button in the bottom right.

2.  **Add the Repository URL:**
    * Click on the three dots (⋮) in the top right corner of the Add-on Store.
    * Select `Repositories`.
    * In the "Manage add-on repositories" dialog, paste the following URL and click `ADD`:
        ```
        [https://github.com/rigerc/ha-addons/](https://github.com/rigerc/ha-addons/)
        ```
    * Close the dialog.

Or click this:

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Frigerc%2Fha-addons)

## 📦 Add-ons in this Repository

Below is a list of addons available in this repository. Click on an addon name for more detailed information, including its specific configuration and usage instructions.

### [Romm](./romm)
**aarch64 only for now!**

![Supports aarch64 Architecture][aarch64-shield]

## 🚀 Installation of Individual Add-ons

Once the repository is added to your Home Assistant, you can install individual addons directly from the Add-on Store:

1.  Go to `Settings` > `Add-ons` > `ADD-ON STORE`.
2.  Find the addon you wish to install (it might be listed under "rigerc's addons" or you can use the search).
3.  Click on the addon.
4.  Click `INSTALL`.
5.  Wait for the installation to complete.
6.  Configure the addon as per its specific documentation (linked above).
7.  Start the addon. Check the addon `Log` tab for any errors. ✅

## 🐛 Issues and Support

If you encounter any issues with these addons or need support, please check the following:

1.  **Addon Documentation:** Review the specific documentation for the addon in question. 📄
2.  **Home Assistant Logs:** Check the Home Assistant Supervisor logs and the logs for the specific addon (`Settings` > `Add-ons` > `[Your Addon]` > `Log` tab). 🪵
3.  **Existing Issues:** Search the [Issues Tab](https://github.com/rigerc/ha-addons/issues) of this repository to see if your problem has already been reported. 🔍

If you can't find a solution, please [open a new issue](https://github.com/rigerc/ha-addons/issues/new/choose) in this repository.

When reporting an issue, please include the following information:
* Home Assistant version
* Supervisor version
* Addon name and version
* A clear description of the issue
* Steps to reproduce the issue
* Relevant logs (please use code blocks or pastebins for long logs)

## 🙏 Acknowledgements

* [alexbelgium](https://github.com/alexbelgium/hassio-addons)'s add-ons were a big inspiration and help in developing these add-ons.
* The Home Assistant Community & Developers. 💙

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
