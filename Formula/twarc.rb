class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/ef/d1/db68767d9080c3f08c52e2e582fbb01a49af1248ee37903111ea9fd1b15a/twarc-1.3.8.tar.gz"
  sha256 "272877413e0393d330f286745481f42a1c075634538d0751c4d4d9b5a5817ce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c9e12b3a8186162f01b176b02549483730923659fc24c999c53ca57f008b053" => :high_sierra
    sha256 "5e55d6077b80d4bb7730fce16bdc6bb3416b5613a173c865a8a18c94bcdacec6" => :sierra
    sha256 "a8b985d77dc3b48d5e5bf15d03d91220ea7d7a7ccab001feb9577f8803f964fd" => :el_capitan
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
