class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.4.tar.gz"
  sha256 "7539129b974c0bea342bd7c65638e52b559df1404679bd4414b73a607c3463d9"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "2403c43de3ae0821265c5f6c87f401eee801e8e63544b08faa911061784c8a55" => :sierra
    sha256 "a9985cc9486270a6ff7ae5e0b3114f81d3dab140c4364d369a2e766bf218cd3b" => :el_capitan
    sha256 "01e156c9849826da6ae28f3e1e385f4f03a1af156c0a1c5ce0e7801a77e05fa6" => :yosemite
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
