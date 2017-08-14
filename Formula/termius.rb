class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.1.tar.gz"
  sha256 "52722e29e9d9a480f4a862ae944ccac180d9829f0792b7ee7209ccbe1600df93"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e1c497b46f29d73507a89c532d0043b8e346d4c0405f952678c0cfe8d039e5d2" => :sierra
    sha256 "5564fbbf5f438f3f150840cbb01e654e68129d9bdc54695901fe55d1284609e6" => :el_capitan
    sha256 "f4f058b142ed9e78ade6094f9c826a30d4b1a2f6da8337f1c8942314ada9ece3" => :yosemite
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
