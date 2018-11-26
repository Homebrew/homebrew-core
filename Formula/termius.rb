class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.12.tar.gz"
  sha256 "89be6d35e5c4918c0d9e3f2410620d3a84c7108e52c2c87cfa6166c5612e08ee"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "282eda73f7577b057f5e02594370262155b6bc2e8415831ad6db0e5bd3a85df1" => :mojave
    sha256 "11caefdfa58dc01f65251fbb8d2d7158bfa88f294d84fb0a7f16af829426f009" => :high_sierra
    sha256 "495c0c709c331514900d5f0805da1f25a28353808fc4e6634ba3f5aacfc4256c" => :sierra
  end

  depends_on "bash-completion"
  depends_on "openssl"
  depends_on "python"
  depends_on "zsh-completions"

  def install
    venv = virtualenv_create(libexec, "python3")
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
