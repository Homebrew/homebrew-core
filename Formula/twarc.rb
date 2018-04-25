class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/1c/22/61764a25272de3b05424cc75b8ce871659c3fec1928232e3e6f17d2efbeb/twarc-1.4.4.tar.gz"
  sha256 "9248bb4782384d9af4523561c943d66190376acdb4e6fb44b5934f357cc82c9a"

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
