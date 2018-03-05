class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https://github.com/DocNow/twarc"
  url "https://files.pythonhosted.org/packages/61/6f/1a8291891d6956aba611347bf0de5424b01a436d5939ebd924a19f0bc2f5/twarc-1.4.0.tar.gz"
  sha256 "844ee2a3816074e4dfe2edd562713c2dbead88779b43fb36ea8b186be79e62a1"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c9e12b3a8186162f01b176b02549483730923659fc24c999c53ca57f008b053" => :high_sierra
    sha256 "5e55d6077b80d4bb7730fce16bdc6bb3416b5613a173c865a8a18c94bcdacec6" => :sierra
    sha256 "a8b985d77dc3b48d5e5bf15d03d91220ea7d7a7ccab001feb9577f8803f964fd" => :el_capitan
  end

  depends_on "python@2" if MacOS.version <= :snow_leopard

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
