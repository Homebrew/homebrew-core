class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.22.tar.gz"
  sha256 "0d707b86b4bc239501d7d7be47b1bcaa4082f36ab6e7d16c64dddd3d870e35f1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "63c7f8315964482db3d4d6cf3a0417d6e62f6dc8bc162d729f7da301aac219fb" => :big_sur
    sha256 "02e68d6bd5c8343eeefbfc39de1babde9686df5792cb4a6b3134efef12fa0cac" => :arm64_big_sur
    sha256 "2621211d63b9e7b2d5feadbd41aea9f71a953032b00b91a67b483b17b6b4bba0" => :catalina
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
