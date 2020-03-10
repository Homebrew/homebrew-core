class Scour < Formula
  include Language::Python::Virtualenv

  desc "SVG file scrubber"
  homepage "https://www.codedread.com/scour/"
  url "https://github.com/scour-project/scour/archive/v0.37.tar.gz"
  sha256 "4fcb961586d8a6d98ac9343ca5647421b98fdc79b51d81a1d3d18576b7908823"
  revision 3
  head "https://github.com/scour-project/scour.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cfd43767bc7e4fa7ee903db637b45c3117ea2e3250e5459387546c97bc8f08ca" => :catalina
    sha256 "c2a82bca29949c3162b21d35af0e1ec7ab54697511ac3e25e79abbb2ea418161" => :mojave
    sha256 "51e2a9e3abba88c05924fb48b2337836c3baf147bd1058d8e1e4af9343cb596a" => :high_sierra
  end

  depends_on "python@3.8"

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
