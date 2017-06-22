class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://github.com/DocNow/twarc/archive/v1.1.3.tar.gz"
  sha256 "cd822e7eb07329fe87377af7cedd74cf1bf48b4d368a85e27dab0655f2afab8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7182eeb8b0d6372cb41c751ff721c1dbcb09feebb877d8f62e3ce999c0d49291" => :sierra
    sha256 "98a7b1b349d5e703fcc92323429a6bff6be91aeedcef910558dae463e8283198" => :el_capitan
    sha256 "f6d50dbf6aa58a90046151d19f70131b735adfaf5f5d6bc58bba6583b17aa109" => :yosemite
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
