class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.110/threadweaver-5.110.0.tar.xz"
  sha256 "a0ea5936aafa0226648b89d8c12c25557ae42c975ad08fefd6cb67f04f25be20"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5151394cfdb6b5cf37a0815e8cdcff1e0253a4df57c88d42eb46fa33474ce1df"
    sha256 cellar: :any,                 arm64_ventura:  "c38c2fc1a582e7f8da0a568f13189de9f94ceee725f45890c0fa08d7b727f62e"
    sha256 cellar: :any,                 arm64_monterey: "ca4d55e979ec9547ffd8ccd38448d16d6d4206969630683ef42b8496e07ef1dc"
    sha256 cellar: :any,                 arm64_big_sur:  "8e729b4807684070b545842dfda8c540726b915a901a5bb37a30e23fdf30dcf1"
    sha256 cellar: :any,                 sonoma:         "9a029c526461854122d612e6c7f3fca91a4c8d4c0c61774efd4d0d55128b62ae"
    sha256 cellar: :any,                 ventura:        "73bd8295610f2b3ef9dcf8f6e46ff937ae10f0660bccf3fc9b4da7eeb7fc0ef5"
    sha256 cellar: :any,                 monterey:       "6abe7ca6f36f1834168cf1262d26275bae8eeb1e7a20b28ad8e86134baf1a9be"
    sha256 cellar: :any,                 big_sur:        "7722b1320859f076d3516646730796326109e3ed1a8b4d18d85cc52c50579261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e0113d0247af1f544dcd706db46c61cd61c51b0d6f24015c1f777bdd8b2b9d8"
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
