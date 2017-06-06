class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.1.1.tar.gz"
  sha256 "5a6fd8f418babb567d5972fb3395553660c0ccaefbd3823115e1b3793d26c9dd"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    sha256 "12dcd31f5d01d7cca04b2535beba7e0f505030dc2188786cf43d866dd6313621" => :sierra
    sha256 "7c3de76008494deb4b7eff6eb7cab469d755fc1048de6c95b7ffadd0633be059" => :el_capitan
    sha256 "814a5efd7d14b220a51ce3101ce159e9f8ce7fb6791ff0a1670ae2b9fc2f4023" => :yosemite
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
