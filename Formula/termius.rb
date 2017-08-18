class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.3.tar.gz"
  sha256 "1003b77f76895c158cca1801982fc22a2cea41c2ea80cb0e697330753abaae27"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "6508f76711adbcbf56f402298ec8114d57ccb3413de1cfe604848ab120c828cd" => :sierra
    sha256 "e76d0d4754bc8f097023858644f416b62b6ddae2a16e97311512478e6dd76a0a" => :el_capitan
    sha256 "89d34fc96551dd1936f660f46e4b600be91d9a3ffe34d1df10478199de9ef50c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
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
