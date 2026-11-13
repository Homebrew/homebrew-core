class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.30.tar.gz"
  sha256 "20a745585b5a78a800858b46af0a585d4dad59f802a22a343d2aef114022a907"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f52e646d46fd10ad5357e8008b3a10f22f499817c8c72f275679b724e01ae5ae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "925c7f2d341ff331eaa0f5cb4b94801e8f53fced78e5bff073b773b03e9176f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "89f55423cd411feacb7d341c0271b60292a31736725918dd3b96c908668d9067"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_path_exists testpath/"rio.toml"
  end
end
