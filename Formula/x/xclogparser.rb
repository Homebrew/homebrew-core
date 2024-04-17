class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/refs/tags/v0.2.39.tar.gz"
  sha256 "b225891b94bbdb549ddbc9ffe838ad87f73ef7cc79934e3e23969bb1220eafd9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2af489ea40d0e2ea3d490c151137cc74992e17d9e5d4ea842efe37bb5c3c83f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e19d4da37201c378b92ffd06a507898d63d294edd235084fc5e5122348914975"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1228c821cb757a23ffc94f27cabe4d8096cd2d317328d2155f7b601e9f6858c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9013e93d887c83d7c4148e225185aafcce876cd1e95ae640d43056520177ccaf"
    sha256 cellar: :any_skip_relocation, ventura:        "d6d2526690a5598b53da6b34361276063540ac8f376600f52d61bc8884364211"
    sha256 cellar: :any_skip_relocation, monterey:       "8ab8fc7785b340892fc87599aeffe8523a60e5b0abb45a3a23a9d70b4da28261"
    sha256                               x86_64_linux:   "8709b44656e8e3f3c943627d72a49e92d99e3d0f487cc1552e5d7d22cf65c313"
  end

  depends_on xcode: "13.0"

  uses_from_macos "swift"

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource "homebrew-test_log" do
      url "https://github.com/chenrui333/github-action-test/releases/download/2024.04.14/test.xcactivitylog"
      sha256 "3ac25e3160e867cc2f4bdeb06043ff951d8f54418d877a9dd7ad858c09cfa017"
    end

    resource("homebrew-test_log").stage(testpath)
    output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    assert_match "Target 'helloworldTests' in project 'helloworld'", output

    assert_match version.to_s, shell_output("#{bin}/xclogparser version")
  end
end
