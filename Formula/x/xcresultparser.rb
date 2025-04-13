class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/1.8.5.tar.gz"
  sha256 "47011cd0bb3ad217780274555af50fe38f03d8e9deb4fe03ed7a3c1e782deb59"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5611ac80b73a2e3b80d2031a753f88c719a5aba3ed8971071fd72fa3d56ff520"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d08e43a313902ca8e9415c071afd632226f73f18ae975564a054b312724c4c80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b0efdb380802a632850cf3245c3eac499bece9f0217dcbd4ee38afc74f80e9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e2d94de14b2fc48ffbdeeedf8d4f9d818c1f49393e7f7bc7699672300ad33487"
    sha256 cellar: :any_skip_relocation, ventura:       "d451ea710acc90edca7d55bc1a0906c581f3f6d8721fa0280893b178ffe1e9e9"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcresultparser"
    pkgshare.install "Tests/XcresultparserTests/TestAssets/test.xcresult"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xcresultparser -v")

    cp_r pkgshare/"test.xcresult", testpath
    assert_match "Number of failed tests = 1",
      shell_output("#{bin}/xcresultparser #{testpath}/test.xcresult")
  end
end
