class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.1.tar.gz"
  sha256 "9d1ea725852d6448985fafb91e18e3ff057172e0b8973440e413197ca4c05bf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0827e2034c1338c8bc7d2f8175aff11fb15aff32c4c08582f3f511d6104c4ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed83fbdc0021f6550e878586af042b422d594c77c7dbb33c6e20ae4d098157cd"
    sha256 cellar: :any_skip_relocation, catalina:      "fe347e5f26966d9cdaefefc36c3d8e8584b4bc25edb30b71a5c90e06dc615534"
    sha256 cellar: :any_skip_relocation, mojave:        "2799817d0e4b094a7dd98549d94a3372193cab26a9d2d9d5059fcff0e520faa2"
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
