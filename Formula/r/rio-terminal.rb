class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.4.12.tar.gz"
  sha256 "0e58095ce82f086b2c392eae6c3fb7129d2b74950d397cf313607c1a66973057"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "155cf6d00109870476fa4c710e21eeb11225aaebd65872d5a812458814701860"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5db3004119b7893fd9978eb2eb39cdaf0784dfe984b8f95c98455c61eb6ea2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8669832079a8b1e875403a6df0c2a60ba2f57dc82e1955462519ec9c3bd113fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "71d3bcd091cbe83d5e37a410203a0359f54872c60789357faeb837a04b66fb4c"
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
