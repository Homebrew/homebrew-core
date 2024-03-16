class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https://github.com/walles/riff"
  url "https://github.com/walles/riff/archive/refs/tags/3.0.1.tar.gz"
  sha256 "a6a8e77b82aa6462aaef2bf43c45eb8381582f3e107b77d65ef8541a459ad68e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26588a5b49c6307c333d59aee5a69bf6248c2c7e5412a95ed32d0d6c00ddcb7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9c6c40a6cd023cfc90822aed8c24b4de34a4810b139a1e0c4162283587fa324"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9240fc953746fb5de140ef1a0b3a0f0a05cebd2828016c6077476b2bd9606c2"
    sha256 cellar: :any_skip_relocation, sonoma:         "da00dd007131585b1de738fb2eda92a41ecf24332933ead3fb33760f0c50215a"
    sha256 cellar: :any_skip_relocation, ventura:        "bb8f910dbf3d3f50b0c6f9424e283bfcfe073e87645e3cbc62b56c399c9b9863"
    sha256 cellar: :any_skip_relocation, monterey:       "d36ddde1d22a13efb99d1661a5deeae1a69953010174236131ac5270eaaa190e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3a7cde44269dd593765fd8705fdc32e5ac991439bf38f8eb3568d8b768ecaf4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}/riff /etc/passwd /etc/passwd")
    assert_match version.to_s, shell_output("#{bin}/riff --version")
  end
end
