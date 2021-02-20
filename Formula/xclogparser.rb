class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.24.tar.gz"
  sha256 "038b8d72041efe08a268f87be5090053349eb69fb66109d3ea64d1ce254ccddf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "60b170ffa8cd4800bb609fbfdee254fd21f8abb0728d3d17d51d7fd2b89f7ba5"
    sha256 cellar: :any_skip_relocation, big_sur:       "6c9c9166db6204b2df972d9ad10c98cdbb97c98d15968433307e8d721fb7f3dd"
    sha256 cellar: :any_skip_relocation, catalina:      "7ef43ceb1b3d7734b6c9f39ae134c3ee018fa851ea6ee415f7671a5396f28ceb"
  end

  depends_on xcode: "12.0"

  resource "test_log" do
    url "https://github.com/tinder-maxwellelliott/XCLogParser/releases/download/0.2.9/test.xcactivitylog"
    sha256 "bfcad64404f86340b13524362c1b71ef8ac906ba230bdf074514b96475dd5dca"
  end

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/xclogparser"
  end

  test do
    resource("test_log").stage(testpath)
    shell_output = shell_output("#{bin}/xclogparser dump --file #{testpath}/test.xcactivitylog")
    match_data = shell_output.match(/"title" : "(Run custom shell script 'Run Script')"/)
    assert_equal "Run custom shell script 'Run Script'", match_data[1]
  end
end
