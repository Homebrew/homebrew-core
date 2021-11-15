class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.28.tar.gz"
  sha256 "b47885b599b9dce44a69e5b30d9da32f7abf9f25e5decd12f5f3313322e93242"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7440029f037b29220706cdd3cd36f8952b3e5659351eb07cbc70b6b011ef47d6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5d3033285545ac4e9f6102bd262ef16d0fff388a2fd913a93ebd9d7c25eeb53"
    sha256 cellar: :any_skip_relocation, monterey:       "b3328492a46c6247e54d2c377fd31413b8946c722a6bfd1cab604f9aa0d05a0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca727b0d65c4069cc1a9683d6b69b932f6cab163c91537f923f50d936aa344b2"
    sha256 cellar: :any_skip_relocation, catalina:       "e023d7644d5e9f790a66037b8427c711f1fa6c881f5df7c341447c2576a30f65"
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
