class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.12.tar.gz"
  sha256 "89be6d35e5c4918c0d9e3f2410620d3a84c7108e52c2c87cfa6166c5612e08ee"
  revision 1
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1cead2d7979a518cc70f85b4b36bc76d63a829acdecea8ea0cc6ecd2061a6435" => :catalina
    sha256 "b9e728620fef8cdddc7eb7da4b1f065fa47d7fd4322fa45c8fd27753d37dfbae" => :mojave
    sha256 "c4dbd02697de6f8cdee9fac085e170c83c66002b369804967c5c667eae580752" => :high_sierra
  end

  depends_on "bash-completion"
  depends_on "libyaml"
  depends_on "openssl@1.1"
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
