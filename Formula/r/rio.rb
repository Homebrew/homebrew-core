class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "0fed33065bb1d5c8549b2c15a960064075ee2773b509207783abd2bf5d522c4a"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c57c630cffd6532d0e3bd5088ef8146b7c529c719931de268db99bf2dec71f60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b3f25c488ce34b762cc02328f0b789cdf3466396313df5eac5e2942aabd725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "96285f19ba8d610a63841c0fa7aba59b6d73c6a662c199575f654025d5d4e4a4"
    sha256 cellar: :any_skip_relocation, ventura:        "8c66897647a804f3eb2dd6ac1f7d16c48f96701a5b7787af3a26406e0466e6d5"
    sha256 cellar: :any_skip_relocation, monterey:       "55e4880f2b9784bc36eefbb637867afab58538f32fceaca509dbe59388e01874"
    sha256 cellar: :any_skip_relocation, big_sur:        "662085669ae6326a63c01a58459d3e1bc257233e0f69a5c5044dea47407434ad"
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

    system bin/"rio", "-e", "touch", testpath/"testfile"
    assert_predicate testpath/"testfile", :exist?
  end
end
