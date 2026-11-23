class Xcresultparser < Formula
  desc "Parse binary .xcresult bundles from Xcode builds and test runs"
  homepage "https://github.com/a7ex/xcresultparser"
  url "https://github.com/a7ex/xcresultparser/archive/refs/tags/3.0.0.tar.gz"
  sha256 "bd68629dddbbd71da01be69266bed0987eac973d1f2b497349282fa89b7b96c3"
  license "MIT"
  head "https://github.com/a7ex/xcresultparser.git", branch: "main"

  bottle do
    manifest_sha256 "0e105b53133925b35d3f6077485da85beb6ab3afd9be1fa4858ac126ec087db2"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "99b7df49ee3b582e1b3266a33050615f6e11d1cbc96a7d04f462cb2e45daa342"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bae2567a29616506108afb55136cbf7fbcd16d3578d15a6297aac13811f4bc6e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b554b904b42e42b01509fb770131375a4829edb54ae84b1656b044fc076a1f91"
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
