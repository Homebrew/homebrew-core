class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/threadweaver-5.99.0.tar.xz"
  sha256 "ca4612ba1f6fc97f863fcd6e725ad2fb80d5d3109e5a3afd0aa0553645667bc8"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c88006858bd7e84e8b6f0d4c58836feedded05153e0eb53df6f79211ea1cfc97"
    sha256 cellar: :any,                 arm64_big_sur:  "63f466ff8633625e670d74f87838ef5c5a033cb397c422e0a19ad8afe70a8c97"
    sha256 cellar: :any,                 monterey:       "bc725be77d8e13f38c7dbf632c5c11a234c728304f9e70bc83d20e4056497f29"
    sha256 cellar: :any,                 big_sur:        "1da72298cda52dbe9a63fd93351420460cd323063f64c596eaae0932e7f7314b"
    sha256 cellar: :any,                 catalina:       "fd790731ec055c00ffd460c3ca7e93a40a7ec157f76a15a1d5057fc7d6a25ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1289d406e009fbfc07ba842b028292218d5f72818395afe2c3a00a49c7367c2"
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
