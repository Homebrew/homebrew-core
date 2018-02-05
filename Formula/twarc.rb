class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.3.5.tar.gz"
  sha256 "122eebbdde18496a0522c48f8cc6eb3b4554d06dcc191a55c63467fdf8bcb1e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "44777a56081504622320b03f153b5c988fffe976288df820a07ba7650c48d011" => :high_sierra
    sha256 "e9435c9c26982e5fd421879ceab60b9da9e4d9afbce30ac42898ae99d54255b8" => :sierra
    sha256 "511109d8e30da42fd44759f553ef22ab7f08258c418160007346f44e42234e04" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

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
