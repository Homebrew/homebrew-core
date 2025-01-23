class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.5.0.tar.gz"
  sha256 "6249242b4fd6e008b450839b2cc053c3c0646a2650480e74238b5230db0a657c"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b5e6320d82c36928355c618bab3cf5b5e9a79ca3a673f048b91950cd92635595"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "098ba57586cd4b119d0b0eaa5ec921ee25fa4314e1e7914a8a72f501e5ebe057"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b74b29010437cf3d372604bc75b1831f329c280c9ee153bb9a088339bbebb78b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b346e1cb444820d593a5ce1e3e9e24cfebbd078a05a106b8c2ef0321ba74259"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a53e2b985ed3d3a099648c0e462f2191d9a1a100e14dfa9a89d7cce736854b5"
    sha256 cellar: :any_skip_relocation, ventura:        "e8ff181cf5cac1b5af9b29c893e3850875853cf4c2c75a99c2034c0517f43078"
    sha256 cellar: :any_skip_relocation, monterey:       "795a50202ea38c203f8fec23a8ae20f23e81c2bf5effd893d6747b1f6c3abb63"
  end

  depends_on :macos
  depends_on xcode: "14.0"
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
  end

  test do
    resource "homebrew-testdata" do
      url "https://pub-0b56a3a43f5b4adc91c743afc384fe1a.r2.dev/SanityResults.xcresult.tar.gz"
      sha256 "e04a42a99dc05910aa31e6819016e5a481553d27d0dde121840f36fdb58e57b7"
    end

    resource("homebrew-testdata").stage("SanityResult.xcresult")
    # It will generate an index.html file
    system bin/"xchtmlreport", "-r", "SanityResult.xcresult"
    assert_predicate testpath/"index.html", :exist?
  end
end
