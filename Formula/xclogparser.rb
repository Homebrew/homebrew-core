class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.27.tar.gz"
  sha256 "2e8f22a5ba095b2d1450379cd94d080306a41b3baaf87d64b9f5c807892dc347"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28153d5c4b6ac4cc17573c80ea3ff2a56fb2933c2442d484369864990dd705fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1adea699bc508e81a3df58c63cf17a7f65f45a5de475b9815581cd263af3e22"
    sha256 cellar: :any_skip_relocation, catalina:      "b21d1b69a9754b7d2677e28d16106109864648e32044f7fd13943f0c8122c244"
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
