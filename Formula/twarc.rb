class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.3.4.tar.gz"
  sha256 "ae2abc431334f422716d6a404cb2a76e54f9e453e097310e50b60aed647cfd8d"

  bottle do
    cellar :any_skip_relocation
    sha256 "29d898b67c632a760c8d18a029a73a8f2c15d15253aebcc1cb34f69b1878e7da" => :high_sierra
    sha256 "953aed242755db31ddd666e3a306755c366205e0498726a6c230780b21a3c2ee" => :sierra
    sha256 "742f966e52e41ecd64e9ed5ae3ad68b7cffa6f408eefddd0ab0df0c0c6ff08ef" => :el_capitan
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
