class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.12.tar.gz"
  sha256 "1d2403c70fb1fe382e1849d5bb6d09a72eb6b76a0a551176dd247339a4f2940e"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92eff0d911ab241d56f665285833e252c775f0af163df0767b49f61dc9ed75c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5c55ee098e55f5e49f6ff92989366d58a96db66922b78e927c618692abdc483"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e7e8aba4b847f8f005c334f9576603c56484e92ee5e3c8695958b74bb4326bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4405f2b8759856f307e15fd3f4832f0b63cecd48aa73369fea88aa1f47d6c07"
    sha256 cellar: :any_skip_relocation, ventura:       "a0a70301c5a3f98ec3d87cb303b187cffe018107ef5fe574947a3c1c13267039"
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
