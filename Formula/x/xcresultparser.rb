class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.9.0.tar.gz"
  sha256 "45ebdb55b5b161ac5a01042239fcf789eac62eac291042dc73c6ed6e4a1d7249"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ce1e09cc08c0e4d9ef2f9064b83720e5c3bd46ae9802e1b77264391f663a3db6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52faae04ae6a5c5dea7919728cd959fc7eba58f525ea922d977dc2b6e71db7f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a3a9a0524696e91cf1ea4b92301fe2df6994c253ba1aa5bdd7c9299d5b6a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b58b1849f16e2e0b2094c0b4e01172bbfb7006748df11aef05b4ec221e7c599b"
    sha256 cellar: :any_skip_relocation, sonoma:        "134f7b0663cb761f62bef72d8ec5ce91fd3f20ba6f6058ba2de05884ebe08be2"
    sha256 cellar: :any_skip_relocation, ventura:       "02ff25269a8c88bfe3a584364f9a96cbee6837c944935b3c6bef62b8665f80af"
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
