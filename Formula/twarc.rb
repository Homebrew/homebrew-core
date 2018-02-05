class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.3.5.tar.gz"
  sha256 "122eebbdde18496a0522c48f8cc6eb3b4554d06dcc191a55c63467fdf8bcb1e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0c1a11d87f5bb563a2224d6447edc7a56cb7de3891cacebe26acfa807043b4c" => :high_sierra
    sha256 "c7d705b12b131b4aae538fdc66d141784f14b241818061b4f747230a49822dda" => :sierra
    sha256 "f8ec23c361355ed745a88c0a64a186e5622d71452b331dc2cde3d73e9498c3ff" => :el_capitan
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
