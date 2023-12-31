class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  license "LGPL-2.0-or-later"

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/threadweaver-5.113.0.tar.xz"
    sha256 "f749e4225640daa4650f4b6b6a31aa4ff523b14b13885309f042ecf25a3df1f4"
    depends_on "qt@5"
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16f83bf34b6e95b6584eb2c11c88dd31eec6d9587dea9066ad8f5388bc0e676c"
    sha256 cellar: :any,                 arm64_ventura:  "d5807db33f8915418cc10b5594416c4bf79c6d9705d5693b66957cf26fa5a5f4"
    sha256 cellar: :any,                 arm64_monterey: "ef521c732d2c44b9c2fceec081878d03b4665a55a4a9fdd57427a8f62e86f84d"
    sha256 cellar: :any,                 sonoma:         "a773d1b7da2a9554790d489022b3710433066f91e97a836b4311ffaf1e9c8b7e"
    sha256 cellar: :any,                 ventura:        "4472272e2bdaf44d0885f0dba943c1b4bead9b7ade790455fc0768b8d65b6968"
    sha256 cellar: :any,                 monterey:       "413a520c1e1572cbbc1ad215ce839dd6800994c65c733786537a92cd773b828e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2def47067c832e87ad1d637d2aa3a0960fb74f733bb40e551780cf399864f3b8"
  end

  head do
    url "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"
    depends_on "qt"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_args = ["-DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core"]
    qt5_args << "-DCMAKE_BUILD_RPATH=#{Formula["qt@5"].opt_lib};#{lib}" if OS.linux?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
