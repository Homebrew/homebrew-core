class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/0.2.10.tar.gz"
  sha256 "87a0c38f1bc56f18b8a7b4ad0022197eb93d0b667ac8e90fbc9bb99b75f2002d"

  bottle do
    cellar :any_skip_relocation
    sha256 "09deffa507cad0f4e5943b6d7ac5c9c4b3885c650c8db847dbd6e35d51e4f68b" => :catalina
    sha256 "421a24fecdc48fe1c6b3f9b59b59c08ac1e7ca3679c9fa4b221172c2c59a5f48" => :mojave
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
