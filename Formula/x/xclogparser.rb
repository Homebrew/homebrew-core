class Xclogparser < Formula
  desc "Tool to parse the SLF serialization format used by Xcode"
  homepage "https://github.com/MobileNativeFoundation/XCLogParser"
  url "https://github.com/MobileNativeFoundation/XCLogParser/archive/v0.2.36.tar.gz"
  sha256 "d3b2e0d75b3c6920535398c882d75c92f901262a302a344a75fe23adfe01e10c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4563ff5ac2c03cb10b0bc33b41b3d97a56c99bf0a3c0511924d5ef18374602c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb83245ca0057d737291cc85e863341cfe4fdfcadbb5863bd9d462e748b38599"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b422ad12e5b7a6113460778c5e1f78bd728d926b8e0a3bd37697d82f15a34e51"
    sha256 cellar: :any_skip_relocation, ventura:        "668b6a84f964e11a7f51a136e4343de59c2636a8d5d1e78fffc43ea522984ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "e9fffc983c4c0b6657e064e512b18bafb20a56c98a2d3305ad8fff34e7120c97"
    sha256 cellar: :any_skip_relocation, big_sur:        "de504bfd1d8d5ec7b84f7755461187d9718fe9b814fc6d781f566fa7c6968496"
    sha256                               x86_64_linux:   "ca6680fd588fa15a2227693d76ec24f87b46185e9cf4366e9476e9b77c31b0a5"
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
