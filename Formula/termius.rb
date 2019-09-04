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
    sha256 "f801f52981e96110777c57834b03e4f3c870f1172b15f0e2575150a2ff0f5136" => :mojave
    sha256 "889d254460c3892d6c96fcd5057984ff649e84431c4d03678184dd78f7be98d0" => :high_sierra
    sha256 "f2f40553971e9461a1a426b8c1a92c581c5063181f3483f19f0b95fc1dfccdb1" => :sierra
  end

  depends_on "bash-completion"
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
