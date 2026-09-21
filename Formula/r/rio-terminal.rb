class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.28.tar.gz"
  sha256 "80ddf991cef26b8f49a80b911d35c7361879f4e072479410d29f1b67dd965213"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0793b7a438b242d0d3e1d6ba125b487a91e8ce0ea9d358ca495797b93dc7d78c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dec962e11139f8e0a308406aef911713bd4f4f3045886c667eba86da3de627cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b1b2d6c86028bec14bec6f8a778e8c066de4a030655e7f7a4063eca19b7a6c5"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  conflicts_with "rasterio", because: "both install `rio` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    system bin/"rio", "--write-config", testpath/"rio.toml"
    assert_path_exists testpath/"rio.toml"
  end
end
