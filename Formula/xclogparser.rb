class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/v0.2.34.tar.gz"
  sha256 "25e1275229064e314ce6f1107541891a5a6438c76a10ecc6d2b592f5a441713b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "994fa1ec0e1e3f31bf142c624b757eeb919b6768ad26537cac04b7210ceb9fd3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4213857270f8c4a2183b1db5e4d19b362d773fae69e0325e312a13357af18904"
    sha256 cellar: :any_skip_relocation, monterey:       "1c4a457594ceefe0bd397520db0d20ff2284f18c27eb5e73bd21227b2f0bfd9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc3ef11105330e603348299884e3b639220d2c0fecde7c3f4a67bc15aadeac40"
    sha256 cellar: :any_skip_relocation, catalina:       "8b1cf6b196da874f6bf466356579df3d7a644cbdc66c8c141e374c4736a74b4b"
    sha256                               x86_64_linux:   "1022ff8d803b5607c74040b869f94169b917689d62f09e8244e87eb21ab4b4f1"
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
