class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "b5adc4960b9e08cbcb72d8bb0fa6f1f5196a374f3ab418b97d676261db9e56fc"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35f7377af9c5885f647be8fb24931e6595c92a3420bab657fe24fb4146250dd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7d19d8789afed829e9ced2b5cf53c9b0d9ebeda3caccad21963d43010656949"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e96ecfd70955034247acd33b00b7f2857f7fdb999455b19eba0f555ce44cae3"
    sha256 cellar: :any_skip_relocation, sonoma:        "64d6dfc0b4c78c6f3c5e169d606e8032ca11f9b88a24c9383385647c06b4d380"
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
