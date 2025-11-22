class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.36.tar.gz"
  sha256 "378cb6c0a0b46495afc1e79ec202b81467de6bd96d88e48e7713e785a3719ff2"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d7466444a8b9f1cda7974cd34016e0160ac3b4983f6b2cb1c388daeb0b51f3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0eba2188c72c1b81d55af46c10077efe85fd6b46ab98877a3b63412d953e5e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fbf9a22eec154d84eed1995d591b21de422a00d4f8193e07a5c0f251c1773b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ba2f5a2f9d563e4b0580d230cc4c4fec66f56dea292f44e47a6caa8c5b94971"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_match "enable-log-file = false", (testpath/"rio.toml").read
  end
end
