class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.85/threadweaver-5.85.0.tar.xz"
  sha256 "431b4a480d200bf12e88ce510efd56edb062eb2284d4233f9602ae62a75da555"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "12b0ddbaa64c06f0e397b1bf4138cb66d9a67410612f17d07dc3ca1a5163bc43"
    sha256 cellar: :any, big_sur:       "0bb84bc6100bf7f8ffa4a00810a968fe20b5d232b2d44bb38b73e92338eddc7d"
    sha256 cellar: :any, catalina:      "281aed45a595c7b9059ec1e4920f01e6fbb6bc154e9ab627d59f2587f5072646"
    sha256 cellar: :any, mojave:        "1690ecbdd928354c86b38d4539c00fb4c2e79530a8ff1eb2100a9b136522ffa9"
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
