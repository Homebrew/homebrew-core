class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.31.tar.gz"
  sha256 "e8374ff8b5806a79e85b34ddd73f0894b3e22639a1dd584cae7f6df5b82edf2d"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aa7f72aa0ddc9a608f7fa3169917dc054044ff5ff38dec427fb83d12001c1ec0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ad6705c8217dde4b58946bbcc398cd1b6c6c73421a249864de3f71e4730973a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9b5835271f97dccd338332245a551f75e063d6c87ab2672de1d81a20b8517206"
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
