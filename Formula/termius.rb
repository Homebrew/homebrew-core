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
    sha256 "dd6dac978e87abdf96cb0753173a512c6386bd7c5a82748948e1e82f52d3f3f7" => :mojave
    sha256 "6551a7e79db714c170aedd84bb86195ff096e7d075cf8543fffbeaf039d143c9" => :high_sierra
    sha256 "58582c97d30d33182dde604df28f5202114130358a0fb5a8887f5e908deb7061" => :sierra
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
