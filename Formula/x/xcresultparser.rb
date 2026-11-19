class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/2.3.0.tar.gz"
  sha256 "2ee9d6af50c7c9a06b7c444e8384998100b22eeb0f86424055caf26859bdb25d"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "162a84c6d7628ab7cf32c0f77a1e5501006a9a08c7106b5f8d7dd325412d5074"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff100065a1e9b245402b1dafcdfcc30ded7aa484a03c764e1e29a0b45664515f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4806fe37e6dd28386cb7545ead79f03e469be502a54e88c1ef899f286dabdacc"
  end

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system "swift", "package", "resolve", "--disable-sandbox"
  end

  def install
    system "swift", "build", *std_swift_args
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
