class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.9.2.tar.gz"
  sha256 "310106d2a51a545371e7ba4b70526c66c6e2515ac42a786b423d8f4751439381"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b8a9f148fdd5f9f01dcfafa101d2b232666b46443315abfe2244b9307c62b614"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03a7ef6c82fab37a32b8db5b461ec29a9f89e9d7a47ddc88d0a632a25ce7ebc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf3c96202d56c32fbf09f4d10bc870012080cb76041bacfb2d73c863cf9e8c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f74323285c55080c096e8480d715b670f77ead4ef72200ea9ccb4b1d5a18f4d"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  uses_from_macos "swift"

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
