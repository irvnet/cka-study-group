


### Install Neovim

Update System Packages
```
{
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git unzip build-essential
}
```

Add Node.js Repository, install and validate Node.js v22.13.0

```
{
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
node --version
npm --version
}
```

---


Many Neovim plugins require Python support for features like Treesitter and LSPs. Let's install python, pip and [pynvim](https://pynvim.readthedocs.io/en/latest/).

Install Python3, pip, and pynvim for support of Python-based plugins.

```
{
sudo apt install -y python3 python3-pip
pip3 install --user pynvim
python3 -m pip show pynvim
}
```

---


#### Download and Install Neovim
Fetch the latest stable version of Neovim directly from its official GitHub releases page.

```
{
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt/neovim
sudo ln -s /opt/neovim/bin/nvim /usr/local/bin/nvim
}
```

#### Verify Installation
Check that Neovim is installed correctly.

```
nvim --version
```

---

### Install LazyVim
Install LazyVim to provide a pre-configured setup for Neovim. Install LazyVim by cloning the starter configuration into the Neovim configuration directory.

```
git clone https://github.com/LazyVim/starter ~/.config/nvim
```


Launch Neovim to trigger LazyVim's plugin installation process.

```
nvim
```

LazyVim will automatically detect missing plugins and install them. Follow the prompts to complete the setup ane exit out of NeoVim

---

Set Neovim as the Default Editor

```
{
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 100
sudo update-alternatives --set editor /usr/local/bin/nvim
update-alternatives --display editor
}
```


Check the docs for the [NeoVim cheatsheet](https://neovim.io/doc/user/quickref.html) to get familiar with some of the extras, or with the nvim open, just hit the "Leader Key" which with the default LazyVim configuration will be the space bar.
