class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.3.9.tar.gz"
  sha256 "34ff0b37341c7955e9c7691f1bd8f32aeb593df51c4d57a60a5c31b3e780251b"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a589c66b4b0f712d5c240f848d8e28fc6aa556ea63cf5ab453639d84d1ec16a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f252199cf0c0dbcbf1f6aa260781af143e7ccf9b45c122b6e8a2f80ab178feb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a665c6f3185177416e52c7d7274c9a2bf9c3db47ca5d1d046e75180de5a1f881"
    sha256 cellar: :any_skip_relocation, sonoma:        "f505b6270dbbcd311c29ad5bf79f2183dfe1d05a30ab5dd2acaa9810cb87dd15"
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
