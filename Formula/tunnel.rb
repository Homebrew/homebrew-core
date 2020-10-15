class Tunnel < Formula
  desc "Expose local servers to the internet securely"
  homepage "https://tunnel.labstack.com/docs"
  url "https://github.com/labstack/tunnel-client/archive/v0.5.15.tar.gz"
  sha256 "7a57451416b76dbf220e69c7dd3e4c33dc84758a41cdb9337a464338565e3e6e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "b13e5a208e756bc66a56f9e85ed2d5f1456b5a58055213b1c1579223da0c4ba3" => :catalina
    sha256 "d4d2c6b802eb2f4fb03628481ec7251b52fb05e536ef161ae9e6eb96d4afb8b1" => :mojave
    sha256 "8425650fbc2fad854ab561a0590e4a899e235882a72f40d95fae4bcb1115c094" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"tunnel", "./cmd/tunnel"
    prefix.install_metafiles
  end

  test do
    system bin/"tunnel", "ping"
  end
end
