class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.4.1.tar.gz"
  sha256 "a27aa4bfa5ea3a96890d65df017dd5d69aca93d635c46df3ebfa245b9d1b7b90"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9231402a6c75bd56b2264b9ce904c92f8c7ca65071c12e8323ffab98199aafca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c72ec799a6540e7110ebfa8faeddff9e7ffabe691e525a599b5e7e933488df55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a695179ba21b5c1d562fc66b25b6dbaae8a43865cb4d436ffa222046466b1e01"
    sha256 cellar: :any_skip_relocation, sonoma:         "a960216604448aa01a76e18e90a74dce186978e49d1f91e5594fc75104b3cf0f"
    sha256 cellar: :any_skip_relocation, ventura:        "cdfd4bc8cb92496621467f74da74ad8bbff1d5ab1b92631d030a4efe849a8304"
    sha256 cellar: :any_skip_relocation, monterey:       "9c49c8918e26d5b582f623b3de61e3d563aa8c83b9bb2c1dcc7d2290f2f7a790"
  end

  depends_on :macos
  depends_on xcode: "14.0"
  uses_from_macos "swift"

  resource "homebrew-testdata" do
    url "https://pub-0b56a3a43f5b4adc91c743afc384fe1a.r2.dev/SanityResults.xcresult.tar.gz"
    sha256 "e04a42a99dc05910aa31e6819016e5a481553d27d0dde121840f36fdb58e57b7"
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
