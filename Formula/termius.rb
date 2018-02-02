class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.8.tar.gz"
  sha256 "65d95ae4cb6f07f703cfe1d360e5bd29be1d354732fe75b51ee2f17bf4dfa18f"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "8de16ff6802e9b239a79cffab3c3726314e71c9fcf1e578cd8ff9f7cd61cfc69" => :high_sierra
    sha256 "ab3d673f249b8d683bcc490c1083f78453d968f0712c6c12b66d0ee4988469a4" => :sierra
    sha256 "efb92919390b5d3766c50b528dea76096c9223870fabd02cc43965bda809f7b1" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard
  depends_on "openssl"
  depends_on "bash-completion" => :recommended
  depends_on "zsh-completions" => :recommended

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "termius"
    venv.pip_install_and_link buildpath

    bash_completion.install "contrib/completion/bash/termius"
    zsh_completion.install "contrib/completion/zsh/_termius"
  end

  test do
    system "#{bin}/termius", "host", "--address", "localhost", "-L", "test_host"
    system "#{bin}/termius", "host", "--delete", "test_host"
  end
end
