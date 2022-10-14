class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.11.0.tar.gz"
  sha256 "943d6f66045658cca7341dd89fe1c2f5bdac62f4a3c7be40251b810bc811794f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0a0e93024e9b076e830b378139f17f4ded0abe8e9d78ddcebe5cb1bff08f20d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19bcee4c76f93016a059ffd43c3a892537a430297d9aa212b78d5454f5427057"
    sha256 cellar: :any_skip_relocation, monterey:       "8570807ea670cf971c338fa22e669323711a29ca0eb2523706519bc014aa5ace"
    sha256 cellar: :any_skip_relocation, big_sur:        "d096ce9912b60128cf32539e8d5cb01bdb670998c9a822aad70799cb0c01a575"
    sha256 cellar: :any_skip_relocation, catalina:       "0efad7161a7198a08f9f83c3a79ac4e9ef8bff37ee4ec13a1bdfa0e1c41d1bc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f51fbae6e8d881ea4701adcffba0640dfadfe5558389738e87c9077a79c81c1c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
