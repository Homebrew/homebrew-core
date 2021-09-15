class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "767bd856724fe5f8558016eb163d032891215a99e9b1c78716b81f1b3d99d37b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0994c3baa09de48feb88d933a70b97f91f68d52a85bf3e14343d19fed091e578"
    sha256 cellar: :any_skip_relocation, catalina:      "b13e5a208e756bc66a56f9e85ed2d5f1456b5a58055213b1c1579223da0c4ba3"
    sha256 cellar: :any_skip_relocation, mojave:        "d4d2c6b802eb2f4fb03628481ec7251b52fb05e536ef161ae9e6eb96d4afb8b1"
    sha256 cellar: :any_skip_relocation, high_sierra:   "8425650fbc2fad854ab561a0590e4a899e235882a72f40d95fae4bcb1115c094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3964669aa7c99a6eb5ea3b5d0fe3b9ea13083e04db6e2aa82e8996c2750a0e8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    assert_match "you need an api key", shell_output(bin/"tunnel 8080", 1)
  end
end
