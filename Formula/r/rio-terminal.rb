class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.31.tar.gz"
  sha256 "d3969961ec6523652981aa40f77595a21fafe667b8f0314346dfb93011ebf78f"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62df595898a93be0b3f1cdb79934cd8da18277445ce664d31119f9024a6ea7d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab2de9e46fe41a2a25c78ed555aecef25c13bbe9870af37966467e51fbf535f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf75b4bba3debc9bc12539c54fbbfdb82fce5458247a09d12b7ba7226ecd453a"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a7c5b3999b66167dba894531c4e0cb34d77199471065bcf93d3a950bf4bf7d4"
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
