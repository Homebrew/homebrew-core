class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.0.tar.gz"
  sha256 "358798d2a35bfdd0e75887638e70773d696fd0692ee33257a796e3855613296e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24e275d2b33f33b26fed232868d1485ce5a1d4a882d3710b715b484919a57fcd"
    sha256 cellar: :any_skip_relocation, big_sur:       "ad745cc5ef31c405301232d11cb75b768a001293a9d150704a4c955c8f38a698"
    sha256 cellar: :any_skip_relocation, catalina:      "34e735d76b7417fa426161d4ed2b27b891e0f040070ccef3d6f430a637b9c453"
    sha256 cellar: :any_skip_relocation, mojave:        "66ea6247ba2d105e5953814cdb9746ea2264a22689d879e16ace3c18e42f92f1"
  end

  depends_on "go" => :build

  # fix the build, remove in the next release
  patch do
    url "https://github.com/chenrui333/triangle/commit/1b77095.patch?full_index=1"
    sha256 "32f15bd419ca122ae6e5d38793d1f3e4446569327ad05281f1a499226faf8f73"
  end

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
