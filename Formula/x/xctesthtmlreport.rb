class Xctesthtmlreport < Formula
  desc "Xcode-like HTML report for Unit and UI Tests"
  homepage "https://github.com/XCTestHTMLReport/XCTestHTMLReport"
  url "https://github.com/XCTestHTMLReport/XCTestHTMLReport/archive/refs/tags/2.5.1.tar.gz"
  sha256 "8d5a35bb8eccd8eb49f923c8169e46dc3a669aa274bbdb75cc92d97ae1e76b36"
  license "MIT"
  head "https://github.com/XCTestHTMLReport/XCTestHTMLReport.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e248b63e1d364801b27aea0d7a709b36d36f56567de68797d21e18c2b072042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6befa1b9ad7d3002a8f90f25c0387d6fd95b03f923891d29a759d3ae0119a81"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3580d4f15dd4fa8865db0f53ed950dfcab35f55070a3888fce5563d2d1a3e139"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9137f28799e7c82a8f3f6662dd1196c7ceadd780ab6acf2223cddf99de3b6d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "79a84112939771f88b58c8f7ef61c7689716ae29bde3bc07061d458b6974b322"
    sha256 cellar: :any_skip_relocation, ventura:       "03127ae2494f3dcbf1af0c87578aeb1e4fe4a0d04df39262db4b868dbf5754c6"
  end

  depends_on :macos
  depends_on xcode: "14.0"
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/xchtmlreport"
    generate_completions_from_executable(bin/"xchtmlreport", "--generate-completion-script")
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
