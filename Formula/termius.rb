class Termius < Formula
  include Language::Python::Virtualenv

  desc "CLI tool for termius.com (aka serverauditor.com)"
  homepage "https://termius.com"
  url "https://github.com/Crystalnix/termius-cli/archive/v1.2.9.tar.gz"
  sha256 "30a966a3629920d77b1af9720b87de4a9dba903836a56f84379feb30ee7f32e6"
  head "https://github.com/Crystalnix/termius-cli.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "936e2abec6645125af9daddcdf76e58148d3a34dc1f903b9ef3ff5b90d8b8928" => :high_sierra
    sha256 "301e1dd224c2803d5dfba24781f508e013d89124730dde9f2d5852a1aa5d0122" => :sierra
    sha256 "73605c67db92dcb5877f8b29e488c09e12b22b93a4edde49c3e895d53ec2f0b7" => :el_capitan
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
