class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/threadweaver-5.80.0.tar.xz"
  sha256 "6a3722a5c927eeaf8e9841fdcb513018ea41f384f41c25a1542cc52bdd43b5c8"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 arm64_big_sur: "9db34c9a77a039eb54ef9699ccc23b2233d3f51c7fef724c6fa0e126dc06af4e"
    sha256 big_sur:       "c47e6ed2b643b8e0e73a3df11b612a334c6ae85d5766db2c2f1ead458de6d44c"
    sha256 catalina:      "ce4895bc462087f14d7bc68613a1cd320800651da53527915094787ec170a46c"
    sha256 mojave:        "1ae5d21684f5f5cd7266a3dada3f3cc077231575025f2e5d631ef6586fb95aed"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
