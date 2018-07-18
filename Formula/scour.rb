class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.37.tar.gz"
  sha256 "4fcb961586d8a6d98ac9343ca5647421b98fdc79b51d81a1d3d18576b7908823"
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9940790ad4ae3872d69ca7f9a2c527731ee9ffa0cee469b04e817fb037f76cf" => :high_sierra
    sha256 "93a3f7709a108cfcd233510889209e8bbfca244679aed9c7b1e905a9bd25ba01" => :sierra
    sha256 "5f3067a66b5415bb5b5514e1a35298efb917e2114f9c369e8cd271977115b2a2" => :el_capitan
  end

  depends_on "python@2"

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/scour", "-i", test_fixtures("test.svg"), "-o", "scrubbed.svg"
    assert_predicate testpath/"scrubbed.svg", :exist?
  end
end
