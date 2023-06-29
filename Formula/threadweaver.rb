class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.107/threadweaver-5.107.0.tar.xz"
  sha256 "c6c4faaf3c2b2197d43fddae39d752c4ad32febee039eb8048f8d705c1393af2"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7220ec2c72acbb3dc25ef889607551abb3a43b7e365e638563f051bce174187f"
    sha256 cellar: :any,                 arm64_monterey: "e5daa768afb479487e6240630d5b06766ff161f611b5ffcbfb8e63750f1e2d29"
    sha256 cellar: :any,                 arm64_big_sur:  "c01825d546e0ef276c0602c23666a7dfa0d793fee7a53898b2262b98b6ceb4c1"
    sha256 cellar: :any,                 ventura:        "e2476d878b29ed3c3fa07da65834915f03a32ca8abe9fb9c989cde89e4b1d18b"
    sha256 cellar: :any,                 monterey:       "9d8e21eb574657f0db38359646468f5d17f2fe4de7626b69dd67614ca2ea68b7"
    sha256 cellar: :any,                 big_sur:        "70352bdb043bb4c2badae076497158df0981cf39402a2ad1b68b8cca35740b9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c0869675996e0bcf33d42b5c71c07d8751fea21630eb4047b7e9b2817b42435"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_QCH=ON
    ]

    system "cmake", *args
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
