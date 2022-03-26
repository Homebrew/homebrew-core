class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/threadweaver-5.92.0.tar.xz"
  sha256 "48b0cf3d969437eaeb0839cbb16a35209336fc6e78c1540920f91bbab8b01101"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a0bbdc0d703db9b8258d9878b63954f1c10b250473611a43b8562c4a2e69ed3c"
    sha256 cellar: :any, arm64_big_sur:  "ddd1d3dd807326858d637352dccac890924fab61fe5dcb091498211c3747f2c7"
    sha256 cellar: :any, monterey:       "66a941a0430b57c3ca63c5e4a4bccd575c63f4ae0c06a02c956c2704581571ee"
    sha256 cellar: :any, big_sur:        "87f29b70a0919d4f356376bf513471530bdf682e81ca3a7e2df45ada6c5b87ed"
    sha256 cellar: :any, catalina:       "74b8f24ad415a7155954f839882a768fd9c3424912b4ebe93c3d346652ec8292"
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
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
