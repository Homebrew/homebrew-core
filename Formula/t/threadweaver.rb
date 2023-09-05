class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.109/threadweaver-5.109.0.tar.xz"
  sha256 "7274529540c4f478519271655a409e4d89c297683eab531a764cf2e5b8c2d2e0"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0032f47dbef0f3f73b0e33ae6ee6f02b31fe67bb5368b9416895eee670cf9566"
    sha256 cellar: :any,                 arm64_monterey: "700faeae1cf4e8cb43b7816e59332050fd8de4730001ff4567e781c135e1f12d"
    sha256 cellar: :any,                 arm64_big_sur:  "b5dcf83de962bf1e30148b1f20fcc0673fe605ad69873627047efa5e7371be59"
    sha256 cellar: :any,                 ventura:        "769ff3147b23d79d73b9fbb7914d6c34dcaff59406f92b2742b2dbc3d41db2f1"
    sha256 cellar: :any,                 monterey:       "0a07bc143da4cc681de5579683a03dc23c4eb3a3e12a69b133cacd2a55d38a0a"
    sha256 cellar: :any,                 big_sur:        "e2c84086e6b3955b7f395a34c5520da513a4aae4ec5b96cb191888dddb7ffbd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f2a3734d5fa68b57e5a51a6df7d2a5a49edb7dd5ddb4576dde823f79c49cccf"
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
