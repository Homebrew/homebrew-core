class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.27.tar.gz"
  sha256 "2e8f22a5ba095b2d1450379cd94d080306a41b3baaf87d64b9f5c807892dc347"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "516b419cf3e2174b5559a4480a79d9ebc5e9c083a5ecdf5899bc129f8d3c1a74"
    sha256 cellar: :any_skip_relocation, big_sur:       "f01442000648fe2f63f605770b4cccf2381cbd5a506d00364646982d718c2a09"
    sha256 cellar: :any_skip_relocation, catalina:      "6811638510465dff36153b98f42a530eae9b7f14b2c8df1dc2a46580d3ebdd5e"
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
