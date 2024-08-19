class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "1cd010b1b1e3d28b87b4c18ca30dc9837a055e1b1f29582fc4fae57a2dcf960b"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad980aa9b6534f39d599f59f404303219ad7e8afb35b8e658ec7d23e16038ccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b514401df34f765ad8c44e809fd1f36f36d40f20fdde589d8151ab6c603df2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "347e69ecee3c74e5a61a1ce0644623c1048e8cfe7cdac6be6b00d403e939782e"
    sha256 cellar: :any_skip_relocation, sonoma:         "c40004b69e88a27c6cac0c7bb99515ab7ac0a4429fb3c246b6f6108926bced5b"
    sha256 cellar: :any_skip_relocation, ventura:        "07b35b2d6d88be9f58125fee7d8f459b1fbf29a04a9a2552541b2cdeb7b1a4a4"
    sha256 cellar: :any_skip_relocation, monterey:       "ecf027d1f66a92fc4ef0be180507b34ed6a18776bc08db73a4768c7fa730f4ea"
  end

  depends_on "rust" => :build
  # Rio does work for Linux although it requires a specification of which
  # window manager will be used (x11 or wayland) otherwise will not work.
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args(path: "frontends/rioterm")
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
