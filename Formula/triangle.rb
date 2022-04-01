class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.5.tar.gz"
  sha256 "e7b729601023620aaba3707db80aeeeee06286e131095da25d248a8325d2c549"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d271336d258f7b6e7aaa4b6ab02c8b212cd7da270d5e3165f8bc08d933e2ffc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a1e9e261e512bbac21587bf240e2ff1dbad618136113338fbb509d50facc2a1"
    sha256 cellar: :any_skip_relocation, monterey:       "b35a46733330343bcc1f97f763f4f35f580c1285042b13248b4b70dbebe1d136"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b54850c650f6c92276b9b06afa3b39701b5a2dd732b0eb9b6172f1a09cdda7"
    sha256 cellar: :any_skip_relocation, catalina:       "013e43ccdf7f8af67aa680faad3e2655cf7cbd44a08e5a459260eff43225d25f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58a213dc45b97b2bf52c5403f52cdae98793da95dd1ac5b9bbaa6fe56197c346"
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
