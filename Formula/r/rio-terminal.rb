class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.29.tar.gz"
  sha256 "83e917dda965f076306030a03073bc5a551b9c1206ec692ff5f85f960d0ea82a"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "adf9d4ff024e4564623b0ac495f553ecf8d08f736b7a7cd0e5e7a3de8195eb35"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0e234b4c6ff9bfa0311f70b71ccaf606459710827e918210ff691a9c737299a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9d628f78834336204dc782f1e406b4aef633c1f19fdb24692099b00e9b820c86"
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
