class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "fe4623d5bed553f1593db2e6385a5a8e24a3731b1814944aaffb72ae5ed12830"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abb7a2714adc1cbf94eb8fbc0aa0cee237a32532ac828a1a366adcee90528d72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9d422db12d64c0ed0701ead6fb6e3a3de61ca14d20a6f2bf3241ae31f57888e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e3348bed6be11fa3b28c8e6105b02594c44d1a6abf332fef018632f194d3700"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd8fff28b4973d56da873ef8702e7438b7afab38f90b26de1f3b2e9e93a807fb"
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
