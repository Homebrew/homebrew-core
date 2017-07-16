class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.1.2.tar.gz"
  sha256 "f024ecaa61e2afcdabaa3255fb335812927a1634f2f6ce8d60a98dab51f85799"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "13dfcb71ea1dee85131fbcb6c3f063373f570209557f8909d96fa3c453bfa85d" => :sierra
    sha256 "2723173520938e5317dad7696ec8effbd978c36971dcb995a01881ccc6ca5f34" => :el_capitan
    sha256 "9f1349a51a5777a106f9293ffe123e5dffd910caf80bf482b2d5a586c57f3511" => :yosemite
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
