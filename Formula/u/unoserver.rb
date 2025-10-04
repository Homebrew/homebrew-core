class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/eb/4d/1bdb4f4a8c7fa128a5ca047672d5760228bafc290f2d5ce8cd46d4d1658a/unoserver-3.4.tar.gz"
  sha256 "3dcf2204013def1d1ddd3671f38b11346bdf349fef9728277462666a8a634419"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3798493d9ba959645c4fe719e058992a090777eafbe662100eba66aad1f5b13c"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
