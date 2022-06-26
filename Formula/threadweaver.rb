class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.95/threadweaver-5.95.0.tar.xz"
  sha256 "bab01c9fc08721b86db274c2a068a2957f8f0a72c5534133425e82af4ef2dd3e"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "454f0c73688e014319582b4f432dfab8264fdd1ef61f12025200e6155d232f2e"
    sha256 cellar: :any,                 arm64_big_sur:  "da351908935cd505d5dce07a762e90b40e101c61416360bf941fd43e33112176"
    sha256 cellar: :any,                 monterey:       "52dff3f75452327da316f5b97fbd53cc37c794f16b5e2c3ba661b7a4c8c87550"
    sha256 cellar: :any,                 big_sur:        "b230068f53863d48755335b883ca3bf9531297996e8a471628f73ffe1ba5aa02"
    sha256 cellar: :any,                 catalina:       "978a7e1083193ee4900f7601e884aff92097aa762a0e30c3d38cc82f3eba0468"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c45689328db0b25d8e4e67025d38f8677d5214ac54f72eacc8efab2886ac691d"
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
