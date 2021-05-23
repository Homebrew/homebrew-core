class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.3.tar.gz"
  sha256 "28296d6b469c212967192f236c8139de1e315d23113f108eec641ce5e39553b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "76c9da2eff5ca28d040fe13d3e4d778fc17cfc347845a666d0b7ae1883b22e25"
    sha256 cellar: :any_skip_relocation, big_sur:       "d2e896b56ebcf1a18cbc0ae67d430ca012b496b6d84fb3264b1f85ef6900d8ee"
    sha256 cellar: :any_skip_relocation, catalina:      "5e0d957825b095173454e7b83f6921164fe72b406a1b1eb6719309ee24be8251"
    sha256 cellar: :any_skip_relocation, mojave:        "cf2344c0bad9d2310e508e38c18a10a2a883481708eed5f2ec7ff53bdd35d492"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
