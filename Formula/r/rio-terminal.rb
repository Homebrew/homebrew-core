class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.3.6.tar.gz"
  sha256 "97c99da527e6a7544f48c07ab6b7a0a6d50a3ea1776a43bcd410e7af8de72b69"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e46473a396b8e33bbdcf4c4c639eeb43e886f13ce3460d39401afaa2b14edee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2461246729de7b7fb1e649da6f7203abc6a150579403e1e5912e364311a1431d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe23325cd23c8809c0b90e265ac925d5e395f54aa46e5bdbe6a8eba08950d4e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa8ad490da1792877ed5a63b7714976d199c6dd66ed4eb1bf4fb58197b20a023"
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
