class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/2.2.0.tar.gz"
  sha256 "6e3d1dbaf7f575380adf2bd4c3a0a24389873a0c7d03d23c4794be37e4f36a7b"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c89ca6259f4cc9fe6e767f93303afd8e2a34fc094e9c8d65885cbf62c6f4b7aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a57176cf99fc6fc28a0cb47e7fa9c3f1ab4a7e9ffe9a2db0029e58fc0cd47cc8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dd804f523e44f606b15b83548fa38bc9a070b467f951d4606f628e21e0036c"
    sha256 cellar: :any_skip_relocation, sonoma:        "533bcf0644b239b3524ea1c98281411ee0d29f32277bf0ee7120cf2b2cfbebd6"
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
