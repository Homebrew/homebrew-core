class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.97/threadweaver-5.97.0.tar.xz"
  sha256 "46975d03feea09c41ac369fd076d7b2c92ad4468a81f48c2eeff622eabfc408f"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d90943a6e120701ced520f7a8b1a55dbd7c35845daf0b5b363c0329fdc191c0c"
    sha256 cellar: :any,                 arm64_big_sur:  "65e2d18ba6a0f5849354e89741f7e0fd8a8a1e3105ca01fae294318b2fceeacf"
    sha256 cellar: :any,                 monterey:       "6ca0edb6df9b965d4d830f296b932f1d7e3995fe9f038206a4c2f4de5db65133"
    sha256 cellar: :any,                 big_sur:        "9af28a8355af43b464d44d4a3020979cba04f6d22b4c8da74ab73fa07d89f3f3"
    sha256 cellar: :any,                 catalina:       "4d74cca53a87ba0cc790ed58768cf4373cf38d768314470eeb9fdf072deaf794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d041b5632e0134c82f4e29a662681b745a3a9b1199f25faee92a02c69bba0cc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

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
    qt5_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{Formula["qt@5"].opt_lib}" unless OS.mac?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
