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
    sha256 "f0cbfbf1df3579bbd13c1ad1ff27943f89fc79adb1c81d34fc1a8455eec793ab" => :catalina
    sha256 "206139ff183f844e57b8b93a9689d5e2120c5fe9e6d3d618bc5fc884d306de7b" => :mojave
    sha256 "969e45c7db350a7506591221ffdf774b2c272bc14bca989a6241612ee4768f6f" => :high_sierra
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
