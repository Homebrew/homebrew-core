class Usbtree < Formula
  desc "Live USB device tree in your terminal"
  homepage "https://gnomeria.github.io/usbtree/"
  url "https://github.com/gnomeria/usbtree/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "09631627589b43ac2e93f6d2a1cf6a10e490f62a159396f35b6871180ad03617"
  license "MIT"
  head "https://github.com/gnomeria/usbtree.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c06d4f12e4afd69f4f958022125400bbbfe53081be44af3179e77f7ad0e2a558"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7ff27115f1567627277e9e11a5eeea4fdb78ef0d939afb0a257885dbe0cd3de8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4f7d42292fc39f57fa827bbbaaebc8624357316b83c6cf960e363a45bfb52fc2"
    sha256 cellar: :any,                 arm64_linux:       "6a0e24f10bb263f3e9fe482b3b6bf024056fd18c94c5c680f993b8c07b576aff"
    sha256 cellar: :any,                 x86_64_linux:      "8c6d0f0b333dff457f1ce64f2a91234833fac46883d14a37db769d08bec2d3b6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "controller", shell_output("#{bin}/usbtree --pci")
  end
end
