class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.0.tar.gz"
  sha256 "fe89d02f6e3656e34e8f734b9f8282d99fd922f45764dfb4d844396d292810e5"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "34d78ac6e3e751688b05df6c37e83e9e2e61d35824146bab003ee601aad187e1" => :sierra
    sha256 "43e3ef59a04980a49d160269789e6611dba9efc426d37adcdac42677b94eb5ac" => :el_capitan
    sha256 "e80caa72f44a3e620e79880147e1677411ba4864098d36270f3ba3c0a616f69e" => :yosemite
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
