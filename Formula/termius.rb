class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.6.tar.gz"
  sha256 "f4bc3e915d92b5c9993cc4a59bae0852ed9003eae0a8280f42bb806b6db28443"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
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
