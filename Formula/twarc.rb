class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.1.3.tar.gz"
  sha256 "cd822e7eb07329fe87377af7cedd74cf1bf48b4d368a85e27dab0655f2afab8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "72c327b36af3efc89b41e120aaa635b4fa5b35bb9de43f9913a712d5b9bbd55f" => :sierra
    sha256 "abd2495c5bb06106cb3a5cb1e089942b4724ca8c7a11907c853e0b50ed270e1f" => :el_capitan
    sha256 "04676fe672e7ba534d9c5ddcdf77c7cf1e15f6f82b9e48a21558bdd08ab3ae24" => :yosemite
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
