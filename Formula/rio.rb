class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.8.tar.gz"
  sha256 "995ad62ba79e1190d15a6e7e353e04750808ccf3d504b5c7d8790cf0e2d999c9"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7095df9f64a6974baf8b9b53bec9b718b49d53fb8b3e547bc4d827e7f1cbea4c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84d122a77db619ff9e3b8feb4c548c05da8bdf4c8604fd159728e0266e6140e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3eeae47a50f131598682198c9013ac89df288118bfee6dc7a7d4273ed0e53ef5"
    sha256 cellar: :any_skip_relocation, ventura:        "e0d2eefc81bb4aef17b8edf503f6eb34fdafae270a667fe4ec9ef616bdee4142"
    sha256 cellar: :any_skip_relocation, monterey:       "1e33182c958c81aa1c9c9dd5071c196a865da3181b852839e7160bf737c03a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "e36fea45ecb6df2fdf963fda129f3d92639cbe8aac6b89d650641e0a488b941c"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "rio")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI
    system bin/"rio", "-e", "echo 1; exit"
  end
end
