class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.10.0/zint-2.10.0-src.tar.gz"
  sha256 "bb97e98a32e140c344e92c8da84a9df413dca16083f2fcdc29791bec77350339"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "77d13463b6479df20523bb8a2bd09214a1a1ad5c6186b8284c642031d4a460e3"
    sha256 cellar: :any,                 arm64_big_sur:  "7e0a1464ff78c64c1be29694571dcfc6b5812ac7202706662a05fce7ba48717d"
    sha256 cellar: :any,                 monterey:       "40a3961b5875fff1e51ae1dba0f2b7a65eabb914261b79a315fa747123c08b76"
    sha256 cellar: :any,                 big_sur:        "aacdc432956a661f84eb7b1b31663b46f97087929a9d1f6aea3ae4a4441da56b"
    sha256 cellar: :any,                 catalina:       "d23cc6ad59e245520ee185e971f9dab0f62630fc3b546d711716e32168967cca"
    sha256 cellar: :any,                 mojave:         "9da4c9094f97924a5093044f6f3c59db2ccf2f6b0ff3d2c7bd75db1eac8b254d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64e38848f0b02b9eb42651b0693ab8bd0abe6b8bd69fefb8fa8fd555d1aaf265"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    mkdir "zint-build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/zint", "-o", "test-zing.png", "-d", "This Text"
  end
end
