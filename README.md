# lede-image-builder
A set of my configs and an image build script for LEDE

The main script is `build_image.sh`. It will download image builder and build it with the preset of packages and configs.

## Build requirements

```bash
# Debian/Ubuntu
sudo apt install -y build-essential libncurses5-dev zlib1g-dev gawk git ccache gettext libssl-dev xsltproc wget
```

## Usage

```bash
nano build_image.sh
# edit script vars to suit your needs

# then build image
./build_image.sh

# generated image will be in /tmp
cd /tmp/lede-image-builder-*
```
