class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.24.0.tar.gz"
  sha256 "8a792c6112e27876a48db09c18fe3032734066193d6c79614d7df1b83f48e744"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3395c998fd2fc8e47ad4b61844e705b31d2df9bb10a3ac5d5c1b7737b040c0a9" => :mojave
    sha256 "43547bbcb11ace05aa7d017528321da7ae2221be9dfc5cae7e75e5a2c6d27147" => :high_sierra
    sha256 "9794fc2530b06c1f4bb4c4f437ed1c94c12ff1848c40cefc62faa628e2cd0bca" => :sierra
    sha256 "fde14e71bc242873257fce9f81c4f73f3c6536a439813df0dfe52339166f0472" => :el_capitan
  end

  depends_on "python"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
