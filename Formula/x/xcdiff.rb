class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
    tag:      "0.10.0",
    revision: "289872e572224ae429d0f4d25ff9be906c9df1a0"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ce60f558eccc79ec85fbbc6487ee6fe864d9b8f839ad64796654ed4105babe5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "567bb880d0e5552caca4190e0eb0d3a0ca1b3f5943f95a5ef233372ae2bead7d"
    sha256 cellar: :any_skip_relocation, ventura:        "206fb28c862e5e9e0a152f7da8d7a1d44c37e17483d7befdbc8dc8e2a4734657"
    sha256 cellar: :any_skip_relocation, monterey:       "7145bb9bd7d4dbe4b910d453660307328c33f06764664a1288044b002efc3b92"
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
