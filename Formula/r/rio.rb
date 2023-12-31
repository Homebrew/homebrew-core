class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.33.tar.gz"
  sha256 "1b2ad697a53918f8badbd7fdfb110ac136b989c80b52cfce14a8507919040226"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d26a4dcede3b4f3dee10cba7aabe5652ed0859ebca10e1ee97c41d65fe6f0a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aa20c70001e2956f26e8cd40fb4daa3e1f0d37670a3c45a5521e9917d810afd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "733c8ec5fc196c2e148ad0a930883f7739439f303a955d18b12bcae4f0858d0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "eede2bd76d263d1e744e61a68b9f0cee88afcd46ddf9be4dd93f1fff73427562"
    sha256 cellar: :any_skip_relocation, ventura:        "ea91e5de97496344761fddce94a924f109e4ec11a64333b6ac551f617a0bbe22"
    sha256 cellar: :any_skip_relocation, monterey:       "c078aa3b0e81e5aafac2592d7b0be900ab4b11d1c687c77140d9b33f424cb606"
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
