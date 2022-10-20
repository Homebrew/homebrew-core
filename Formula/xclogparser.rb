class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/v0.2.34.tar.gz"
  sha256 "25e1275229064e314ce6f1107541891a5a6438c76a10ecc6d2b592f5a441713b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e813bd26c732d18903f050dc8556bcbf44c87c707606e72fc87b8494eced38c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1913c040932b88bc7319db6bf8c3eb388b804fb5b0d93eda35cd4419f7a4e373"
    sha256 cellar: :any_skip_relocation, monterey:       "1471bf0035f4bd72db87c19404848fac8ea922e678128cff0eedf9d8d4713b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "e326d092e7f54022f4cdd0592973c26b67fcffc635e5048da888edc00b1ccfa0"
    sha256 cellar: :any_skip_relocation, catalina:       "16b724430cdb6e6cda995d699123c9fa709d268a8ac33c54bd7e19d50cd38a5b"
    sha256                               x86_64_linux:   "3c22a8bf4058f19ad67afa2ac381779e9fb0561c3589df9fa1f04125e2c6d571"
  end

  depends_on xcode: "12.0"

  uses_from_macos "swift"

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
