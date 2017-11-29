class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.3.1.tar.gz"
  sha256 "5ce324cf1604c7de5a786f48be1c0109bc643954a63b2e3d87afa9960acc79ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa2cfd6c5cac278763adf65fb32d9ed6b5b3abd44f4dfe6cbd03ed35ae0a5928" => :high_sierra
    sha256 "2dacf384642ff9c9ab298d1eec15e92c9cd05762a42c1620c75e465a6f0c9c7d" => :sierra
    sha256 "ae5c8036fd72462444178a0060bf3c016281c9737bbb44fdd454b2b4e8de8299" => :el_capitan
    sha256 "65d96d754bfe03c52b133841235f9185a84f1429dc523b9e6d3ea7b310169682" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard

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
