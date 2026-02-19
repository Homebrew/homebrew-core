class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.37.tar.gz"
  sha256 "f52bcd0fb3c669cae016c614a77a95547c2769e6a98a17d7bbc703b6e72af169"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ec1c734913b51180765a587f8d9833e4953a279f2345bf5dbc01c84bc9ea1cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "46d0d3d9f56aff471da1795f3bb253803939824f08607252f07a9c6d206fae5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f776eb59e654dff52d85168613f674fe2a09aa74f73822cc3dec6685b54bf90"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c89e84004d60d160ca370d253718685329774e705a7e4ce3c1295c703a616ae"
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
