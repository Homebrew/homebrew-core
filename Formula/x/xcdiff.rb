class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
    tag:      "0.11.0",
    revision: "97c45542621ce26fc499f7b414a0a1a08d0c5c1a"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a345a07d757d16b64d0b0da86d330bef9411337d0c53b3773fbe6a91529fffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e144893e3bc36d9d83c406419aecf5b52558f1ebe9497de58625d27ca88efb0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc80240bd985eb9851e4edb1779bd27e4149f62faf3746cb2b27ee14b56557a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "200526f87da30e5b1a56ed823933e0f14585fd88a0b7e536b722c5322a76801e"
    sha256 cellar: :any_skip_relocation, ventura:        "129410c68a81ab2823cf768baa7ded025627742944280a1b47b6bc9dd9e79f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "89cfc3c33f722c723743defac586c80e0b6316db57325ee3d473f3c9f498760f"
  end
  depends_on :macos
  depends_on xcode: "14.1"

  resource "homebrew-testdata" do
    url "https://github.com/bloomberg/xcdiff/archive/refs/tags/0.10.0.tar.gz"
    sha256 "c093e128873f1bb2605b14bf9100c5ad7855be17b14f2cad36668153110b1265"
  end

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcdiff"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    project = "Fixtures/ios_project_1/Project.xcodeproj"
    diff_args = "-p1 #{project} -p2 #{project}"
    resource("homebrew-testdata").stage do
      # assert no difference between projects
      assert_equal "\n", shell_output("#{bin}/xcdiff #{diff_args} -d")
      out = shell_output("#{bin}/xcdiff #{diff_args} -g BUILD_PHASES -t Project -v")
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", out
    end
  end
end
