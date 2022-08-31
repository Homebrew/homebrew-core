class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.2.2.tar.gz"
  sha256 "1d7159e4e66feae6194bec2303690e91db17e2593b597ac0db357942020bf4a9"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  depends_on :macos
  depends_on xcode: "13.0"

  resource "testdata" do
    url "https://raw.githubusercontent.com/tylervick/XCTestHTMLReport/sanity-xcresult/Tests/XCTestHTMLReportTests/Resources/SanityResults.xcresult.tar.gz"
    sha256 "ce574435d6fc4de6e581fa190a8e77a3999f93c4714582226297e11c07d8fb66"
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    resource("testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system "#{bin}/xchtmlreport", "-r", "SanityResult.xcresult"
    assert_predicate testpath/"index.html", :exist?
    # It will contain the expected version in help text
    assert_match "XCTestHTMLReport #{version}", shell_output("#{bin}/xchtmlreport -h")
  end
end
