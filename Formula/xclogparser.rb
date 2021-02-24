class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.25.tar.gz"
  sha256 "535547e7d1d8fd9d9c0513ff1fae0b714f9b6baf0899c067a042cae8dafabc37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32920d474ce58ec03613efa82c3cc9cd28294f3de02636ec316426aeb5647f9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "894dfec102f3017b1246801a9657676d7075fe7d5f747341704f3c8c7d182e47"
    sha256 cellar: :any_skip_relocation, catalina:      "c5d2a88a175a91f94ed922610d860b582e383bb41220935648f9d2270e3fdb69"
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
