class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.3.4.tar.gz"
  sha256 "85e10b9350de8842efba29dd241968ad5112e34429ec1d5fbfb79b713ba98822"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25f0968bab563d1f744b08c35d47f6e7bc55954f65520e0a0781e554b70f8745"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a84083c4a80d8d234262865980098b7b14f891929f0c650e490d99394c50248c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0b1162793fde42637ddf3eb7db6e2a3a39cde34c92623d7876909e968604a99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbf430d113006facac15eb7c0816c7efd1d48c9f354aa66358bec6cefa0cc2c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "f31778ad3d2151873e64aafa1c488dd7c6f496905d5f681503d9bc3ad5f58e58"
    sha256 cellar: :any_skip_relocation, ventura:        "59285b5b0c735ec906c6017b58bdbd3c09d51f56c6a8fee81c8be72de9cddc25"
    sha256 cellar: :any_skip_relocation, monterey:       "949b3f2d12295dc053fb22a5ca832055277046d81dabb93856cddedf933465a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d2906e77f7a67dde660c17dc14b692a9f9831bae52ad013a08ff82ad0510842"
  end

  depends_on :macos
  depends_on xcode: "13.0"
  uses_from_macos "swift"

  resource "homebrew-testdata" do
    url "https://raw.githubusercontent.com/tylervick/XCTestHTMLReport/sanity-xcresult/Tests/XCTestHTMLReportTests/Resources/SanityResults.xcresult.tar.gz"
    sha256 "ce574435d6fc4de6e581fa190a8e77a3999f93c4714582226297e11c07d8fb66"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    resource("homebrew-testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system "#{bin}/xchtmlreport", "-r", "SanityResult.xcresult"
    assert_predicate testpath/"index.html", :exist?
  end
end
