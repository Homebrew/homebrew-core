class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.1.1.tar.gz"
  sha256 "e62b05cf654ee9c61b8145aaea32f54ee39da872cca37084c96db5cda6587ad1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4498b4b6c20831ee695454aa0a8a28628a2a07c7f9a418b6e26c88104cae1c3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "787b0732b1db07a2230e57136c30e74045bc9f5e6985c15135b6cb136042a4cc"
    sha256 cellar: :any_skip_relocation, catalina:      "a90c331e51936a58d69e47b7ce4d9925072b6024ad6b1d1fe9d75b17f2becf15"
    sha256 cellar: :any_skip_relocation, mojave:        "6dc2d0aba307e988e2d4205881be47aef561ab3cea7d7bc5c378e23414782ad9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "d8859fc5b05f1faac1db7cd3130e6e8c8359724fc2162e5d6dc97d3e5198651d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", "#{bin}/triangle", "./cmd/triangle"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/triangle", "-in", test_fixtures("test.png"), "-out", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
