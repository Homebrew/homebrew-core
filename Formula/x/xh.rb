class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.25.3.tar.gz"
  sha256 "ba331c33dc5d222f43cc6ad9f602002817772fd52ae28541976db49f34935ae3"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e4a8f271b52fc229048df16f0e422010c50d10484d8d6eb1b5fa2a9724b5d3ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22dacb461b1174a85e381e512a06f88329b905f0d66a2f129362dc06c34d8696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb25ebe2e75782784f1049ab84eaa78f327527bc835cd4c10d1bf31625f4bb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44547a1508f6ebf8de1943b226971b02ca2958f7a5b57e2b6812470f8b6cb92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "143b423684816dafd6748cce6f394499d1150f677eed136758ceae3dde7c3d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "997b2b36f8648efe2c3ea81e77edcbd3111470c5b13346f850d7f4f03ff4ea3e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash" => "xh"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xh --version")
    assert_match "Accept-Encoding: gzip, deflate, br, zstd", shell_output("#{bin}/xh --offline https://httpbin.org/get")
  end
end
