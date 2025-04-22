class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.5.1.tar.gz"
  sha256 "8d5a35bb8eccd8eb49f923c8169e46dc3a669aa274bbdb75cc92d97ae1e76b36"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f891210797be11eff596d4591cfd5a17040edad1f91ab4e82f05810605748ed"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ba579e5455f7fcaa0dd5e9f5eebe5ef50d0f8c5e722ea8284cc93acf79d5d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ced2a0b67495d2a88bb0c54884826c7803dab81f4a26e9b428be6e9403a7de2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6aa6f58167e54283fb1f2fc7f80cbf08024f577d087cae4f46fc764498ede33"
    sha256 cellar: :any_skip_relocation, ventura:       "110df7a8ab8a1254e30c69397bdca84ba148247d0a9009349a3c36c56c78b088"
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
    assert_path_exists testpath/"index.html"
  end
end
