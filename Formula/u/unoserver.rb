class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/18/3e/00ed93bc9784406515f821757008928a4c9d148229cf5c00c5c805edfdec/unoserver-3.2.tar.gz"
  sha256 "331136b3f0eca52a36e723e2b99f2795f27c8b6d9d8c096ed4ef7ae33cbdf3d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7b161b4609c4c19868eb82bf7fd428deb260633e2a70c2929df1584a401f1a0c"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end
