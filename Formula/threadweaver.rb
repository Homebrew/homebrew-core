class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/threadweaver-5.101.0.tar.xz"
  sha256 "4fd103c528590fa974f267d6de5a709b942cee15247b3d877f27d997ff62fbfb"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f98e5da95486575b59c2b273499f4d75936e7ade78a66b5342c6bf8047df600e"
    sha256 cellar: :any,                 arm64_monterey: "6c3c69abdb37f38b786479a6830e273ff189b3d4bb30967d87810fa22e8676d5"
    sha256 cellar: :any,                 arm64_big_sur:  "1e2ca8ce387eac3b7940cdf80bbadb633157838bea77c1ee0ca7276553a520be"
    sha256 cellar: :any,                 ventura:        "d4687859887091eccbf7f8cacaf23eee7c859490f4e30d835ff5ea46765ff7f2"
    sha256 cellar: :any,                 monterey:       "629dad1ee1d6210f3de008fca5540d3d21f828e52bf12fc2fa8cbd5005fa411a"
    sha256 cellar: :any,                 big_sur:        "542b282f4e1e08c9cfe2806ca3292886037d163e7e1a9dab89fa690bbb0db945"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3c2d07398357889fd6e8a526a97db6145a5a591a20cc614db7ec0f1960a041b"
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
