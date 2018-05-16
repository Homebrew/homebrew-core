class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/aa/b0/230989a312f9af9a52df3b532024cdad5e38050b35994c0a3b81d6bb4a88/twarc-1.4.6.tar.gz"
  sha256 "29f4a70a2ddb54d43caecbdc595d987bff87bed72799e0717924476aa4fcf3bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5293d851dcdf341fff26be9a020c1376d3d7c9ed0f735383dc280f872620dc5" => :high_sierra
    sha256 "6a7848e15bebfbbf509acdc97b5f617723e88b53a4060ea29fbad8c1a23a4a72" => :sierra
    sha256 "ee6d7491a92a9999ba879c2af880419edaef59f735f8feb8ecb53fbeae4ac914" => :el_capitan
  end

  depends_on "python@2"

  def install
    venv = virtualenv_create(libexec)
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", "twarc"
    venv.pip_install_and_link buildpath
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}/twarc -h").chomp.split("\n").first
  end
end
