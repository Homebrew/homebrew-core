class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.3.tar.gz"
  sha256 "1003b77f76895c158cca1801982fc22a2cea41c2ea80cb0e697330753abaae27"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "415cd45e3d1cea4be9182cec7b7a63f9196b1a5e118016e3da573ef03c33a641" => :sierra
    sha256 "7e7ad1e3dcf3f21d1b2832f7ea9f0261a0c0ef04fc679aae3a4a924a09e8d69a" => :el_capitan
    sha256 "5aaf24a901c711b6d391adf14f64517ce430da98d575bea419e6251000efdbf8" => :yosemite
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
