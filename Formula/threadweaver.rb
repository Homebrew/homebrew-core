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
    sha256 cellar: :any,                 arm64_monterey: "3cd1b966274b17803d823e41130c0cedcf366842d62cdb78f07cde40f46e1afc"
    sha256 cellar: :any,                 arm64_big_sur:  "9871ed44a0a184f2222d41b837ed7de8e8dae92415089a81d0241370695b2b48"
    sha256 cellar: :any,                 monterey:       "f8c5e6f74232be9f45762fa1056df7cd3f5723378a0d47f7c2bf3fba1a84595f"
    sha256 cellar: :any,                 big_sur:        "cc1f2b1e4ca40ec8cc752beded38bc50e2c34d4a28f484ecb32f86a8de376590"
    sha256 cellar: :any,                 catalina:       "88e57fb7b220fa0e533dcc283ade1aca7e5a85688a5d82a873b0046240095c24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55e02a0cbb63d8fcab891d5c5514feac33b51a53ed562000a0c47e0030b0dd8b"
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
