class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.4.2.tar.gz"
  sha256 "ab98463c3981eb8ebc0e1b90773d483f39b6af12e06b30598d1e143edf800807"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6567ac13495718497de773f0cdc4b23fc9b6f71be36f088c8b51e2196721c6bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8075a0c4d00ec74e0985bfd52871e27f5f49e4b2fabed49d943f6c69a4a5bf96"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6456acd9d4f7b9381667e7a589b83f8c4842b9a6a43b75b36b474032f9fb7e2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b4172c6329aa1f2971ed5df462f83562f946a14e14a6a3d960bac183052f66d"
    sha256 cellar: :any_skip_relocation, ventura:        "a39d9324b6efb72c3d01deb7d2471bff2d8c1d2316947d5363cf46b50f3cc087"
    sha256 cellar: :any_skip_relocation, monterey:       "56bacc01abafd9838909ed7dd40fad2428010eadd98729589751f4130f74d972"
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
