class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "5f74e4866a109a0823fab25e528ba5eba008c7ece9dba08a87bfee6aa5946fdb"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f03ac5afc4cb4fdd930aa96021253a429401989b5995debe9b50fc03d99029a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b36b29b16cb015131f1884c896534b506b1f8959b10e882a2de8c671b798830e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e26a6cb99a260d5f0740fffc4abd52898a7467e0b4855f4012fdbaa290097ab4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea827299c34c2b768305539541ce257f66d67afc8f4654f0cfac61fcb8ab3561"
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
    assert_path_exists testpath/"rio.toml"
  end
end
