class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.17.tar.gz"
  sha256 "5a5a145eb53fa13eaef85c38546be150da82e139068bd936339832e0d6b039d0"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "35d4a64ff9830ab116d738a5207ba2b20cd85bc5549cb00c2fe0b8b552b1bfad" => :catalina
    sha256 "ff858557ba76ea2e1da7fda2f46badb5acd1dbd6252f580ea87976d5071a8eea" => :mojave
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
