class Xleak < Formula
  desc "Terminal Excel viewer with an interactive TUI"
  homepage "https://github.com/bgreenwell/xleak"
  url "https://github.com/bgreenwell/xleak/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "190a0458a3c61c49c22b97046f8ae6f8ead1c74aa213777c575b8c4ee634f029"
  license "MIT"
  head "https://github.com/bgreenwell/xleak.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bc979de348ff1ec6be5242e9a8463e54e424a97ed7edcfa4c0f94e843708e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "893e86d3d5f99517b31573fb0ac0cd2f415a639578105391ab2a2d7bc2b25db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a75c0adea7fa0ba82415e90224757ee356e4a0d24e3a27569d9a8fbdd059ed17"
    sha256 cellar: :any_skip_relocation, sonoma:        "d38c9643c3ec5123ee32e4c7df475882fa9dcdfe70e338571229065f4445cd73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "508d6a9bf70e935b1b7d6a12fe94a9a240c0529cb00c39673a154725deef1aa9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18ec2991f6222a7a083d933ead2ba84537da49c1827fbe5498a871a103cade11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xleak --version")

    resource "testfile" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2025.11.16/test.xlsx"
      sha256 "1231165a2dcf688ba902579f0aafc63fc1481886c2ec7c2aa0b537d9cfd30676"
    end

    testpath.install resource("testfile")
    output = shell_output("#{bin}/xleak #{testpath}/test.xlsx")
    assert_match "Total: 5 rows × 2 columns", output
  end
end
