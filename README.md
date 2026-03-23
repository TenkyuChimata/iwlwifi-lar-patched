# iwlwifi-lar-patched

Patched Intel **iwlwifi** kernel modules with **LAR (Location Aware Regulatory) restrictions disabled** for Arch Linux.

This package allows advanced users to manually control regulatory domain and access additional Wi-Fi channels and power settings.

---

## 📦 AUR

https://aur.archlinux.org/packages/iwlwifi-lar-patched

---

## 🚀 Features

- Disable Intel iwlwifi LAR restrictions
- Allow manual regulatory domain control
- Based on latest Arch Linux kernel
- Built as external modules
- Compatible with Secure Boot (with signing script)

---

## ⚠️ Disclaimer

- This package **may violate local wireless regulations**
- Use at your own risk
- Intended for **advanced users only**
- You are responsible for complying with your country's laws

---

## 📥 Installation

### Using an AUR helper (recommended)

```bash
yay -S iwlwifi-lar-patched
```

### Manual build

```bash
git clone https://aur.archlinux.org/iwlwifi-lar-patched.git
cd iwlwifi-lar-patched
makepkg -si
```

---

## 🔧 Usage

After installation:

```bash
reboot
```

Then you can set regulatory domain manually:

```bash
sudo iw reg set US
```

Verify:

```bash
iw reg get
```

---

## 🔐 Secure Boot

If Secure Boot is enabled, you must sign the kernel modules.

A helper script is included:

```bash
./sign-modules.sh
```

Make sure your keys are enrolled (e.g. using `sbctl`).

---

## 🧩 How it works

This package patches the Intel iwlwifi driver to bypass LAR enforcement, allowing:

- Manual regulatory override
- Access to additional frequency bands
- Custom transmit power configurations

---

## 📁 Repository Structure

- `PKGBUILD` – Arch package definition
- `.SRCINFO` – AUR metadata
- `build.sh` – module build helper
- `sign-modules.sh` – Secure Boot signing helper

---

## 🔄 Updating

This package follows Arch kernel updates.  
Rebuild is required after kernel upgrades.

---

## 🐾 Notes

- Tested on Intel AX200 / AX210 / AX211
- May break with future kernel changes
- Use with caution in production environments

---

## 📜 License

This project follows the original Linux kernel licensing.

---

## ❤️ Credits

- Intel iwlwifi driver developers
- Arch Linux community
- Contributors to LAR patch implementations

---

## 🐱 Maintainer

TenkyuChimata
