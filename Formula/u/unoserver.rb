class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/d1/cc/9a1af015c16feff14460da12759e7c4b7780d889ed2c836aa91468ef4a31/unoserver-3.3.2.tar.gz"
  sha256 "1eeb7467cf6b56b8eff3b576e2d1b2b2ff4e0eb2052e995ac80a1456de300639"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aafaefe3988c62d3b0afb6eb70f37f921ff09a929a1d0995b408f782bd46e8ab"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
