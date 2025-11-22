class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/6c/63/9e1f7e83a303c5f74f9720b4de12d4742469d6bed0ceaa109d8ece1fed6b/unoserver-3.5.tar.gz"
  sha256 "0924adc3e06bde0361164f25972632fcf6b388a5359c37d00928d061c712d775"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12a10b2dfed522a0b7d9b1f282d6349f0dcf357632a6a473ba3a9b3a8f4b4da4"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
