class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.6.0.tar.gz"
  sha256 "3f7e5e99d766b387292af56c8e4b39ce9a7f0da54ff558a6080ddc1024a33896"
  license "MIT"

  livecheck do
    url :stable
    regex(/v([\d.]+$)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c26d1b774a4bb88e0ecee4cdcf459ec3a22142af55f07fc93fab6bf6e433ff0b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0eb4c8f2100c0d41bd382ff9e4c8bdee1df19e5dbb60053dce90a24339466fec"
    sha256 cellar: :any_skip_relocation, catalina:      "b9ec3480735006f0603df6a0f4ba123f3bf807f8b2c731070975263088b6cc8f"
    sha256 cellar: :any_skip_relocation, mojave:        "cfb99f76c48c5ef48ee89118012a75a8b78c1f3602db084407e3fd4e7f0922eb"
    sha256 cellar: :any_skip_relocation, high_sierra:   "c865fed700599d7619e91ecb815b2672b9a1d9da6b4289383cd5455d82d79743"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
