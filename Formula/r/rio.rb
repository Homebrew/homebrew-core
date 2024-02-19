class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "04094d0dffa2df5bd6647ead3baf6b2a689d248177660ac879de3a3b8cba6bb6"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "85944ee2f0996bc2ab76931a23bce120ba3a804884276ff251859474481743a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63947f7a87fafb0726a7f096933d6630e50660611c0b0a6c9b44792ebf870c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a704fd1e4a3053aa838df238547bbf98c26c99c0d28afedd067654c83018c1e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb6a83514e8288a492cb7c8c1d3934611a07f9aca90e3abe154f2e1132ca4c63"
    sha256 cellar: :any_skip_relocation, ventura:        "7cc5153b09aac6319da5ee0b4a689e78f23c5aa906e0cf97b017245112959adf"
    sha256 cellar: :any_skip_relocation, monterey:       "f3f9a72eacb72dfb572a7a64ab143a93752b9ad737cd159909fd3385931f7398"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/cross-winit")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")
    return if Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    # This test does pass locally for x86 but it fails for containers
    # which is the case of x86 in the CI

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end
