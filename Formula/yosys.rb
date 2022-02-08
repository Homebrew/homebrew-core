class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.14.tar.gz"
  sha256 "8216ab178c0da7da427da806187b556c95a47322c535f2a4e0475197cdf0f2d3"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "e864907be36bf246522849c4c375514e32ea3c088a4f4fe274c2931868d15f32"
    sha256 arm64_big_sur:  "b114a3083170dc0af7fb4ac28b48c68e04477dab1fb1cb36cc600d38a4dcdc3e"
    sha256 monterey:       "0e687765d63f982be9b9463b50fe87d81023c56d178e66917ce22b1169a04720"
    sha256 big_sur:        "157bfcc901029416b64a509310754d70f647b3e7a8c0a8ca96e6ffec0aa694f8"
    sha256 catalina:       "b48672e61c8b1fd88cd9f7e2814290fe6d411a789b76148d490b1d4997a17ea5"
    sha256 x86_64_linux:   "b2145ed8545cdbc676e020f058aa81ea894cc310c57d3a04830ecfb94d5e946d"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
