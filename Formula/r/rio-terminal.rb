class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.3.11.tar.gz"
  sha256 "f59abcfb501bb4e98dd13d471ba4ceba9b7dd25bcd2c45865b2aef3d8dce9a19"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b406c96331032a4b131973733e3db6192984e43c32653fb13a6b337d3eeac0a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c91f9fe6b6075fdcb067ac63ea047f355e97ef1b3bbe89aadb8eedb9b6ea1f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55c6a18c970b3ab8fef4d172846cc48b45079a39387aba7c9db2e62914b860d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c285ff68d00f3a331a5cac0728add011b3f66695474163ab917bc756548c8860"
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
