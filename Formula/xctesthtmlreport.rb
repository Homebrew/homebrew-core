class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.2.4.tar.gz"
  sha256 "d6f015d974bc7b281a531be7482400068bfaeb1b7f58040f197655cbea4900f3"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09adf8c3aaef36698802f2f4ec9df0c54a2c30331793ad02443486e45bd157db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68268a932d48a169c9645c8b9bd9daa7927289736b5ff0bdf8a30363b1d5556"
    sha256 cellar: :any_skip_relocation, monterey:       "8fadf0792948314dff43eeec059bde7cc9ff10494cbb7542c279dca7424dd264"
    sha256 cellar: :any_skip_relocation, big_sur:        "0beaf5cedab2fada15b51b9e6225674e70457aa20ab2f5e682ed89ad3462a1a5"
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
