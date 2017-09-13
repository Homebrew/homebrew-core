class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.6.tar.gz"
  sha256 "f4bc3e915d92b5c9993cc4a59bae0852ed9003eae0a8280f42bb806b6db28443"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "c8f96ab65d9e41bf2045bad4b54b16114c53b35e9c276db81d765bdbff5d617c" => :sierra
    sha256 "8d46dcfd111018b959edb27bff7cfafe0b065a5d79899b06ee942d90cb06446d" => :el_capitan
    sha256 "4a5bc67e7f631ecddefecc81f0d141925253a9d53b330d57312822586fd0f1b5" => :yosemite
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
