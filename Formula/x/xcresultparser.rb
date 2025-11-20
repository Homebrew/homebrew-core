class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.9.3.tar.gz"
  sha256 "7573d3554ea0d73deb8b13e5b524a70be3f5fa43a9cc4f3aea52c3927020a533"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c528dc057085d48aee2dddb4cc81d0486e18576528c50a4937334b1f564c2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b81e88a15fa6ee3fc68959d08f377c52a482ba062d5b675cbd4671e7c22a583"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f6d67425d45cf32a369404ecf0f391116110d60f3cdd9fd748a4c63132bfe2"
    sha256 cellar: :any_skip_relocation, sonoma:        "83e8e7f6f38f764df196992c6096afec7185979abcc2e26ba53398e52441fc57"
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
