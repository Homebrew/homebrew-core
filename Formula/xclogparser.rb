class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/v0.2.35.tar.gz"
  sha256 "c41d79f479e640cd7ad29ac686cf7c34a5772c6739431ad33710bba850a8e43a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ab6f9fc9a46af3491347aae04b72a1767a72280e9972970d448b3bb9ecfb8b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ea11aedeba42960d68e097ef21a0296cceb6c295b3cd5e461975335957e6cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e7e6d595a5695da985c616618f41adbdd41deb1032e29c4e0d0b3478f1de795"
    sha256 cellar: :any_skip_relocation, ventura:        "f1ada4a1b0546aace2fdd176835de8eab0e838f7cd691018ec6f996a851cb37d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf21af81160749d42337cfb922a297be534087caf8ef47d7bd564e5a2d4b5066"
    sha256 cellar: :any_skip_relocation, big_sur:        "02a5d2f1a0a9c8be0369f403fd2a7877039c73d9f73c7f468a8fe00d07410897"
    sha256                               x86_64_linux:   "096bf37eeb2ded008e06cd959be0a85011d759ccbc2cfd715530f757a124eaa5"
  end

  depends_on xcode: "13.0"

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
