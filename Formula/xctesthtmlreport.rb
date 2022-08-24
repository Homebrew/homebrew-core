class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.2.2.tar.gz"
  sha256 "1d7159e4e66feae6194bec2303690e91db17e2593b597ac0db357942020bf4a9"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  depends_on xcode: "13.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    assert_match "XCTestHTMLReport #{version}", shell_output("#{bin}/xchtmlreport -h | head -n 1")
  end
end
