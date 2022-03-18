class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/spotify/XCLogParser"
  url "https://github.com/spotify/XCLogParser/archive/v0.2.33.tar.gz"
  sha256 "bd74c19532f5725203f3b53c0f4119bf6fe41e53496bcb244c05978c83fc4f82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "495b8aeb21c06d9186fb5e4810bd1ef36ba2377769357a476aed7d70c7fa242a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e8432ebb3b4cc15464483e056c96cb404fb882e88fbbcfd37c0c8b945f79584"
    sha256 cellar: :any_skip_relocation, monterey:       "5b794bbec84c4dd4a4a867665928226b817791d0b95ee09fbee8759c1c5cc196"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ebb1b3504239807973329a8e6c4eae4a5cd1bf6839c7456aea36b9901ead0a"
    sha256 cellar: :any_skip_relocation, catalina:       "02a0e5a688b94de7bc21fc773a194a99f30b92f442563360593708e4ccbb6c82"
    sha256                               x86_64_linux:   "420309e800cea377e95d196f305f3350c68427c0413899c445281c0f6bfd0e1e"
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
