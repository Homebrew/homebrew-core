class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.11.tar.gz"
  sha256 "11f9cf3ed783681b208ecc07e37463c915292bc2a39cf5fd53edf76fae27b6b7"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2863e3ba3ea662d96e94f171c98431da852b92aa825430198f351144f2ca262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d470f77666e798e2c34951c750ff6c1da4a4508d833f23d3830d1de0843d6c71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2158a10f4b989cfae752e48a908d106ec8a4e450a956958c0f3965c99f8b7073"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d7c037e41bbdf4ae84b270ea6e4b754af9ee4236df56a4813feef2315867f9b"
    sha256 cellar: :any_skip_relocation, ventura:       "e3abd147522169adeda55340bc925b2421c55a7a08d9860b168fe44536c19d74"
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
    assert_path_exists testpath/"testfile"
  end
end
