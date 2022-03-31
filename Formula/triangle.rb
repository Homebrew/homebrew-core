class Triangle < Formula
  desc "Convert images to computer generated art using Delaunay triangulation"
  homepage "https://github.com/esimov/triangle"
  url "https://github.com/esimov/triangle/archive/v1.2.4.tar.gz"
  sha256 "afa9e43e44e5103950113dc947724c83c03f7e655653974fb534f685f5dc0493"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "563d4012a2846639399afbee7a3e075ce9fb0579beedf8dd8106406e61775838"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "704b24d681e71a55c8c6d3888524ace351bb8240cefddf91060f8d6ead3fbf08"
    sha256 cellar: :any_skip_relocation, monterey:       "42f96ab8e1bb5879b0e0be8fd44ac830c6f8bc5f96866205ee50c6608dec6cec"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b51538505ae028c96c122c565345e97257aef8103614afb14ecce0e5feeafe7"
    sha256 cellar: :any_skip_relocation, catalina:       "5d3948f4093b5bc4f9b5410643eafd26a1d7c1bc87a2eb5ed7126447a46a675b"
    sha256 cellar: :any_skip_relocation, mojave:         "a2549fdd2296b72dc857cfc4fcb89f07f4cf71f2419133ddb06eef63e3c7a7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dd51ff7e1d80c1107c0c95b854db0168fda43a65a7e4bfca3201ad3d949e7ab"
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
