class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.11.tar.gz"
  sha256 "cc8553c9786274de828fc2fc71509e525ef1d8befebb0c74728de59f721912d6"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "37eafd317b786ecf5e640c83e638b40aca67a2c6aa6d096245df1582b3578726" => :high_sierra
    sha256 "4d68f73ba10c090b285cd0051708a0baa4f20d85f524473069853aa05d0a2eb6" => :sierra
    sha256 "46d51f5c8e0e0c23bab503d2c60fcd051688b20d8e835f8ed747e92993517949" => :el_capitan
  end

  depends_on "python@2"
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
