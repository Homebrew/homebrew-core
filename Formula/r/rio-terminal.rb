class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.32.tar.gz"
  sha256 "04e276bc5613a79cb2826a7fe5439c6a6b4bde8560bfd674d79beb5de61a75ac"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "15cff4507860d814efecec6854eaf0fa2004dd6acdf2fccbced78bb03a5c1c92"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e22fe8233e82605825e0dbcc984298751ebbff0e42a4e768332ce7b3afaa877a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c05e38564232404632074b07a2bd719e5e1169753cc5cf4927930911cc90ef5"
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
