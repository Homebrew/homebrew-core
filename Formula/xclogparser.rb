class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.33.tar.gz"
  sha256 "bd74c19532f5725203f3b53c0f4119bf6fe41e53496bcb244c05978c83fc4f82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8cdaf41de7a4506f7d32f41853860beaf80a559bf09353da53802fa01d40c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36158a5b968fded789f0329f3052a2ff6dcaf9297858da946c0341d8ef723fba"
    sha256 cellar: :any_skip_relocation, monterey:       "49642ff71c917b556b89020a73df6d445fb8b0285772d848c225c6c6383be825"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a7b0157b58bd1bcc331d711fce1a634638b474678d0a532ae0cdc005dd3d920"
    sha256 cellar: :any_skip_relocation, catalina:       "d1a458625bbd6142bec2c2498daeea7b3dba1c4321923a1954a8816196092789"
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
