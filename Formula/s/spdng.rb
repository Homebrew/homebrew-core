class Spdng < Formula
  include Language::Python::Virtualenv

  desc "Speedtest CLI with mtr-style path analysis"
  homepage "https://github.com/patpadgett/spdng"
  url "https://files.pythonhosted.org/packages/14/c9/f13d64cc9a5bc310b25b974d7cd1d9f6ea8493568ea85cf2056d8e06b850/spdng-0.7.0.tar.gz"
  sha256 "a470b92697e1b34720d18b8f905a102a7a00d8d517a003454a6b7e52ceb15cae"
  license "MIT"

  livecheck do
    url :stable
    strategy :pypi
  end

  depends_on "python@3.14"

  pypi_packages package_name: "spdng"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "spdng", shell_output("#{bin}/spdng --version")
    assert_match "usage: spdng", shell_output("#{bin}/spdng --help")
  end
end
