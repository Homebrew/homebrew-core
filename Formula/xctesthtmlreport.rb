class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.3.3.tar.gz"
  sha256 "66c1ecb369cb6966a021bccad2975b3b7e6de23a802e724df1e83c0d4d6ede6c"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acfbd8f5f8c36c67b6127a8f8902a847c04d36f7eef8730eaba3b2da10382301"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccacad98433ec052b8c7798e0d02827c696341c31a50e4e79f8100ae505243f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "283ca5afed54b07616d766884b13a8292f572717d87d0edbcc6ca2d996ec7071"
    sha256 cellar: :any_skip_relocation, ventura:        "ce47940f6e024ad0cc8effba3e07b251f845bbd152390600d95aa9ee516399a6"
    sha256 cellar: :any_skip_relocation, monterey:       "99983b990466c3f13f178a22133c88aaeb24de45bb5bd40d54356f72368d7a42"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb98a5d57423ef596d25ce6d4b7d9a38631bdc19c528fe6a539483297869275e"
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
