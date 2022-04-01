class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.4.tar.gz"
  sha256 "afa9e43e44e5103950113dc947724c83c03f7e655653974fb534f685f5dc0493"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79e90e83cf69c04ad4e56ead54679de71721d3cbd0b086030d57e8e46c6e8154"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92bf94dad8d334504ed77d7777ef0e942997657aaf1a76f7238490c4c4812793"
    sha256 cellar: :any_skip_relocation, monterey:       "a9950b4c9f3b44c0332195a3cfd2cd702277d9c8d86e442b26f848434db8d3ee"
    sha256 cellar: :any_skip_relocation, big_sur:        "f66d8b95ad883512b775af5eed483e7d8f8dd6ea454fca03512597d97f700c99"
    sha256 cellar: :any_skip_relocation, catalina:       "cf24c5ae87f11383ea5a20ffc809882153aaa715cea7cb5b0a41892bf8549b7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94da2e8ba34060c472ec2e448bd9f2b4be039491313109a1237e577e0a10a2d"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
