class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.16.tar.gz"
  sha256 "2431822f4fc28fb72555bdb2e3ac8e2097b34296ea9f4ec68ab886c448706afb"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff3a52de3458d323f7594c8c6cda5e37790f02b5cf41f030ebb0dc34b4e96ffe" => :catalina
    sha256 "0384c8142d4f4b708a5738a04917caea51070f1b132cc90b7748790f4c507ed7" => :mojave
  end

  depends_on :xcode => "11.0"

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
