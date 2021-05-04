class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.2.tar.gz"
  sha256 "60e603ad4f61c54e67a5fa16d18a38a2d2a970d3650830211489b365f4afd174"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "db0f0a46fa5715cdb064a83760a6de5dcf27f76dc845f75ee18b4772275ac118"
    sha256 cellar: :any_skip_relocation, big_sur:       "d35a6e246b19814d299d6c991603f784ef61dfb2748bda3d2ca0265b39f24191"
    sha256 cellar: :any_skip_relocation, catalina:      "7574aec1e6a72ee9f6dbb4f3a1ade541b93286b4397e85b090afb6b4ea3448a8"
    sha256 cellar: :any_skip_relocation, mojave:        "5ecd78cf724c405272add18a049f0bd183e1c0bf6de34014e6278cd14d5953f9"
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
