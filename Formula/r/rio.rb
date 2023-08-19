class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "f6e876d75d9be0802ae377b8e1ffc9cb5da2111c7aa68be68d12377b3c006ae8"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5aed44f8c6a9276c6741716ebca29c46be8fec446a946c9d9c4fd1b42032f43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ed5b35165c8e4f19cadc6e7db289c989c39a43f4abb8006d260ed913fe3c80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4469afb40c92e0d9ae8cdff68cbe0032ec740adec6cf649d8619518efd841898"
    sha256 cellar: :any_skip_relocation, ventura:        "fc6d645d60d89a2489ed3deeaf92b4cddac2be134e5da50046e1790b8e041399"
    sha256 cellar: :any_skip_relocation, monterey:       "b361722183fefab4606723d3a5a581b2ef9db0cf0652764c2ebce30d67f11e9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "66dc94b3f1ca467a04dd19d97906cce43d157691d8c973e3f96873740217aef0"
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
