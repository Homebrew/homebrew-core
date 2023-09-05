class Rio < Formula
  desc "Hardware-accelerated GPU terminal emulator powered by WebGPU"
  homepage "https://raphamorim.io/rio/"
  url "https://github.com/raphamorim/rio/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "dab9d3878be4ba5b3bf550f4f9cc4206b3e5ebc58a9c9b8c27d383276b7e8422"
  license "MIT"
  head "https://github.com/raphamorim/rio.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14bc4d83486e06252bbefa6fb0b58f7af20ac4d1ac6e9d2515881e05d2f5d74a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5dc2ffb794f641c87dc2197abbabaef6a2147541d834c880744c2bc9919a070"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10514cb2aa48cb30fbcb54e255a80d5aee6934c02da7db5cd6dfd396d4182383"
    sha256 cellar: :any_skip_relocation, ventura:        "4381997c04080d66acdaccdd03fa0dc16efd319295c18bd03a52a1722ca386f8"
    sha256 cellar: :any_skip_relocation, monterey:       "6d81cb0508d84d792912b21f4b82273e6f3612aeb2e98afd490aa57e3bc99231"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a30ce7a30b7f33c6619f305dfcd5800f7381610730a8a4485e3d88054ae8629"
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
