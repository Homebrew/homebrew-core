class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v038.1.tar.gz"
  sha256 "0d2f88170305d54b143410276ff84da98e3ae9c36abe52430d9c2b510fa77884"
  license "Apache-2.0"
  revision 1
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cc54913deabe91d474f2e2bc1331bf5d1b205cef57189e0caa1c5851bec1a97" => :catalina
    sha256 "98559b6af786373647020f1b4e796d2602e339f48851a3ef3368315c181a4bde" => :mojave
    sha256 "8c4bdb7c969bdb4452baa576ead7293e7dd48cb494447eff0b6264d934f5bee2" => :high_sierra
  end

  depends_on "python@3.9"

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
