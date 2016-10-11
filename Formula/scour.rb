class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://files.pythonhosted.org/packages/cd/3e/b914c3264766621992b0a381ccd3e7342d64640dc560f6aa411cc9594265/scour-0.35.tar.gz"
  sha256 "7b33a0fc7ed578e7d1fcf4f68eb4c38cd080c243ea57537840062d37cd0d3c8e"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e57966bafb1b3cf28e65271b41611feff351b43f5d98d886fc60d32c20ef2d51" => :sierra
    sha256 "5356058903cf2bf00d40faed108eeda659e15e650299c7b66061d6d96d401563" => :el_capitan
    sha256 "67139e0349e79d1627362c91f7e993bf966565ee20babae4964d4cb1db8a485d" => :yosemite
    sha256 "842f1b4f78abb257bb70a08245a60628da52bf18c656e98151ed56db2291eda6" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert File.exist? "scrubbed.svg"
  end
end
