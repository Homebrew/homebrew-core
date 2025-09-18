class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.30.tar.gz"
  sha256 "44343b3f02cdb3fc2153255a0dd01dec8d64f923819576faef18f35096a5958f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03af0e89ce7c00218adff5c01fdb99fbf6ba9c7f2962bb70675b413ed42fccac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "37775572e3b969f65a5ffd3851718500698231f36bcfd3c1faecf20f3c825741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9475d59c9dae1d0f266979d976959d37aeee96520ef4c15bb3f95b7de822cb5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffdd5164dd30e6e5402875b57c7a4a1dda3409d31f374bf2662e0fc172825169"
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
