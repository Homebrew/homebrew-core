class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.9.4.tar.gz"
  sha256 "1d316fbed0ed1df76f434b6231a8f3d3ee71904e1ee415380974094891107f2c"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0cdd90b56d58e1ec9b1e8ba98683309b9e443f08a434660416413fc5ebeef6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e281dd3746fa7f48906e7ab8e1b550e6201f7c5fa9e29b84028b6bf3d91ce7a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be858c9e18747f4007c306792f548416d11f9b8c58d8dbabfbb72d1ca8817eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a7181f5591f00d90252c29c0733370ad033fb0ef2780313c1932fb41f7bd290"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcresultparser"
    pkgshare.install "Tests/XcresultparserTests/TestAssets/test.xcresult"
    generate_completions_from_executable(bin/"xcresultparser", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcresultparser -v")

    cp_r pkgshare/"test.xcresult", testpath
    assert_match "Number of failed tests = 1",
      shell_output("#{bin}/xcresultparser #{testpath}/test.xcresult")
  end
end
