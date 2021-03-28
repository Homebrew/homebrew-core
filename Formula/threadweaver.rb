class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/threadweaver-5.80.0.tar.xz"
  sha256 "6a3722a5c927eeaf8e9841fdcb513018ea41f384f41c25a1542cc52bdd43b5c8"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 arm64_big_sur: "154d556bd5be092fbf3c52bbe727d71391ac9f4a7f0b9ff5ac556c4168006299"
    sha256 big_sur:       "08783647078fee1ef75cdc951014d6a85b4ce8d6cd0eeaf23b8b40a9c3ad995a"
    sha256 catalina:      "8260e7bc8e7b4313a37d0c04d53950066d6c2560d4787d3540f03d7046b034ae"
    sha256 mojave:        "ff1911156f274c60621ea84d2c4747c3342240281a0047c33669562a063c0b87"
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
