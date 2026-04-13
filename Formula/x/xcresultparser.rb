class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/2.0.1.tar.gz"
  sha256 "cd479e6770abf4c390d01ebca7d4727db79d00244351b5adbb2aab2e4d247d01"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1114f7ff74791d9d9695dadd5edc80bc200f1bd4b88d01b6d7df7dfb5f56f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7daba68fc5581a285cc58537b7677ce2aaa5e8300e56e8e915833792f694177e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85b0814f00ee3b4f6f6b04020728c3d824a3dac6df63f8a21de3359fc2d7ef74"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e79f5144e2ec62e20b521b941444384720c3fa5bc88d0d38a58006e03064e9f"
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
    output = shell_output("#{bin}/xcresultparser --target-info #{testpath}/test.xcresult")
    assert_match "XcresultparserLib", output
    assert_match "XcresultparserTests", output
  end
end
