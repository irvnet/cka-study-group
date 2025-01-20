


### Install Neovim

#### Update System Packages
Ensure your system packages are up to date to avoid issues during installation.

```
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git unzip build-essential
```

#### Add the Node.js Repository
Use the NodeSource setup script to install Node.js v18 (recommended stable version).

```
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
```

#### Install Node.js
Install Node.js and npm from the NodeSource repository.

```
sudo apt install -y nodejs
```

#### Verify Installation
Check that Node.js and npm are installed successfully.

```
node --version
npm --version
```


### Install Python Support
Many Neovim plugins require Python support for features like Treesitter and LSPs.

#### Install Python and pip
Install Python3 and pip, ensuring the environment supports Python-based plugins.

```
sudo apt install -y python3 python3-pip
```

#### Install the Neovim Python Package
Install the `pynvim` package to enable Python integration with Neovim.

```
pip3 install --user pynvim
```

#### Verify Installation
Check that the `pynvim` package is installed correctly.

```
python3 -m pip show pynvim
```

---


#### Download and Install Neovim
Fetch the latest stable version of Neovim directly from its official GitHub releases page.

```
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
tar -xzf nvim-linux64.tar.gz
sudo mv nvim-linux64 /opt/neovim
sudo ln -s /opt/neovim/bin/nvim /usr/local/bin/nvim
```

#### Verify Installation
Check that Neovim is installed correctly.

```
nvim --version
```

---

### Install LazyVim

#### Clone LazyVim Starter
LazyVim provides a pre-configured setup for Neovim. Clone the starter configuration into the Neovim configuration directory.

```
git clone https://github.com/LazyVim/starter ~/.config/nvim
```

#### Start Neovim and Install Plugins
Launch Neovim to trigger LazyVim's plugin installation process.

```
nvim
```

LazyVim will automatically detect missing plugins and install them. Follow the prompts to complete the setup.

---

### Make Neovim the Default Editor

#### Set Neovim as the Default Editor
Configure your system to use Neovim as the default text editor.

```
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/nvim 100
sudo update-alternatives --set editor /usr/local/bin/nvim
```

#### Verify Default Editor
Check that Neovim is set as the default editor.

```
update-alternatives --display editor
```
