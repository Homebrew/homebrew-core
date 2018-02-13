class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/ef/d1/db68767d9080c3f08c52e2e582fbb01a49af1248ee37903111ea9fd1b15a/twarc-1.3.8.tar.gz"
  sha256 "272877413e0393d330f286745481f42a1c075634538d0751c4d4d9b5a5817ce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7d8b6f70e358576b1393bd2ca6692ce0e6a07d47aeb04f4680025af45af26c3" => :high_sierra
    sha256 "fb7b76b8b1d3501730195610817863833b8d69af024541ee53c7c427fb0720e5" => :sierra
    sha256 "0e37452cb097ba9a487075f291a3f3ef062e1b397ada7020540a841619b64336" => :el_capitan
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
