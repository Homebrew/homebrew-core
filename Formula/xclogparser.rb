class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.18.tar.gz"
  sha256 "43d32060a10741ea5574222a668f717f4ecf8959b2b5291b46fdf9105eb6ff2f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb5d10df9d5e152433f7b4cf20351daa5af8da185e8163ea3e93ed6796e88409" => :catalina
    sha256 "7839c4146e0ec49ed80018f232cf4fe619188fa6417edd530eb06a5fd2178543" => :mojave
  end

  depends_on xcode: "11.0"

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
