class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.7.tar.gz"
  sha256 "2007785888501b189a8161d9efbca9b8cd6886bef4714581bdb369bc84fbcb03"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "df58a93898554be05679d5e88fad7f29f6935e15161a34dcde38c5c2ea90663a" => :high_sierra
    sha256 "7a83a18c139f04696adfd0f4cf127060cef6b17ca005a0aacdfa543b47047e2f" => :sierra
    sha256 "3476f0d2bc9cac2de557e5d0a85ef09ecccee16b6defe18230f67e7125f46ab9" => :el_capitan
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
