class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.7.tar.gz"
  sha256 "2007785888501b189a8161d9efbca9b8cd6886bef4714581bdb369bc84fbcb03"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "d9c1e98a2d25d73f626972c247326e13edc05e7ef6245b48cb3ed5d5b3192d83" => :high_sierra
    sha256 "91a32e75d185003ee37279ed2f14cd63c59f3ee30e0953dcc85a56cb4fc1aadc" => :sierra
    sha256 "569f5ac20308bd09224009e12d4dc6b8b0140c95b5cf46b141a1512a4e280c55" => :el_capitan
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
