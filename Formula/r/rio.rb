class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "03fb35ae46d3dcb48f3ea193854c8ad959018c364e5b632e0130970d0f18cddd"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fc58b0b02950b931a20e7103e126bb4c3edc172b12de1fcc0dd12984e34c693"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da38ff4ddc69e59eeff1565d9479ab4a5e175fa78eae2b16fb11d1b2f69d3003"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0bf413fa2f2e21609f8a2daac97b147210386adca3c9a9269930599936ef42a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "ccad30d4c45cf1e746aca842164847cd76554a0d07ca77e06534eee73357ca62"
    sha256 cellar: :any_skip_relocation, ventura:       "3a674a112f7894c2b3ce09405d0763d76466046fa6f8a8e0fe3d904bcd8bcb69"
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
