class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.10.tar.gz"
  sha256 "3018a7c290206ea61ef59936ea01caba58677eacafcab844b01a54c261e17247"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "1b43d37c254e794c47286c544fc5d4f18eab191840ec02a5204b0e315693394c" => :high_sierra
    sha256 "e30b066415aa95b92890721ba3225e38e89afbad566887f15f8b404f447f880b" => :sierra
    sha256 "884c8ca4db96e065ed6d6b660f7919f68b0e4715724eaf39015be98cf5ded7c6" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard
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
