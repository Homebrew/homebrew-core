class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.16.tar.gz"
  sha256 "0645113a1677d4a15320b1a8705abd905ab05286113f44b3eada9a142849de20"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60e0f7815ac005bdb04aaeda741ee0c8f8fbb36710d3f6d91064f567890bd740"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1040cd0896cafd0e9ab1000e2bd7492187ebd39f375d355024bafeed04b4db6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24b8a8dfc3457e66622a02e77a386b79d47cdde3a298746d78ca4d8f4707630a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3212ba394d58f010e249d572de9200a19cce94d99bb65f4293af56ee363bd908"
    sha256 cellar: :any_skip_relocation, ventura:       "acfc487866381e11c305e80bfb2b1a4778422106f4e2045d3e37da155b97d305"
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
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_path_exists testpath/"testfile"
  end
end
