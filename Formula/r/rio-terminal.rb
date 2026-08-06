class RioTerminal < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://rioterm.com/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.5.16.tar.gz"
  sha256 "d88bfb518a31d6c650e3cac35304dc17f848b1525832499323d85b78f29fadba"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "90bfa9c6dae4af699a563750e0d9a7ff600b386d0c1384fb2d9127b93bf23776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82329c325f164d6ddbdbf0c88003e6efc4e8e73456840af026fe4a30049e5dea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d2d2bbbce5b4901c35084bce787a3ee473f7390a8f8df5e5a8cf363c1e96873"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e23a67e882505fec5d6fa4d430a5e65e4522d5454ca195b3a3d7f8b42914805"
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
