#!/usr/bin/env bash

# --- Basic system setup ---
sudo add-apt-repository ppa:graphics-drivers/ppa  # add gpu drivers repo
sudo apt-get update -y
sudo apt-get upgrade -y


# --- install system drivers (including nvidia)
sudo ubuntu-drivers autoinstall

# --- Install uv ---
curl -LsSf https://astral.sh/uv/install.sh | sh
export PATH="$HOME/.local/bin:$PATH"

# --- Install github-cli ---
sudo apt install -y gh


# --- reboot ---
sudo reboot
