class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.12.0/zint-2.12.0-src.tar.gz"
  sha256 "bf0a221b798abce65f48b003c0a23fa2fb184f5d35abd0eacc67d091aa9ac4bf"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "eb99fd7ffa1a588669d062578cbf311b44085f7c83e3407e5ccdc6b5003e1d42"
    sha256 cellar: :any,                 arm64_monterey: "1ea226645a7ddb4ed5915a1341cf7aa163886268400f3196d81ae1c86c8d4a8c"
    sha256 cellar: :any,                 arm64_big_sur:  "3ec3f07e1990fb95eb430a0d905370c872ba60155dbb4389932f79439d403a53"
    sha256 cellar: :any,                 ventura:        "13e76452212b86f93c8732d9f33bb532a8cefe525a4b49ca5eb3267251fb9c0b"
    sha256 cellar: :any,                 monterey:       "19f1454a31e8dca4b6d48cb29c81c596cb2e449d75481e9f5d278b7c04398b20"
    sha256 cellar: :any,                 big_sur:        "1e140f68d1824b648f7ffca624fac788b2ec226dbba38b88de32247d2571f4cc"
    sha256 cellar: :any,                 catalina:       "c8ebc9a9fb91bb16df70fa6d63cc7b7012563cc720e4ca91d21ffc0ad298c926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f648339f12e34e52d0caa319e0767dd41e69873345273632bd6ba8a7499157ef"
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
