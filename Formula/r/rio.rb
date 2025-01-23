class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "92a42c41d76d133b7e32644c89522f2e1223eeb2c65b3f07d99094fe1d5aade5"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1264444dc48715ce54633c7b287de861872f97fb590c8a80e57a578b61330e6a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "455a4075883002ffbdf1bcb67b00a4a95f2fdc5aaa915522fd3c5d0fa05c6aa2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cac37183735e9d9119253e89fb49926f6f46fcd74adfa230f29cef0f640c9e2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "4257569d84e2aa5bd0c7c68b6cae8837938ba6297f7aaf343b9d670bac14afb8"
    sha256 cellar: :any_skip_relocation, ventura:       "6411565ce5da1c7c4fa53b7eb682eba6a3dfb6bfa99bcafcb3316c9b0a8205e2"
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
