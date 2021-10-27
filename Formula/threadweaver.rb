class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.87/threadweaver-5.87.0.tar.xz"
  sha256 "904db85af3f4cf5a7b0125264926d83405489feec66cacf675c67019c5fe17bf"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1393ab0dc4b73feda73ec7492cf573755fb2f046c77f7ca14cea2b0d4b517901"
    sha256 cellar: :any, big_sur:       "a068b36279c0b3b55fc77d136e42712d8f37f5efa370f819f51ff65d39358535"
    sha256 cellar: :any, catalina:      "14fab5d7bfac23a31ec7c4ea8940cbe47097728f4f2642a648c41aa9aa7c4f49"
    sha256 cellar: :any, mojave:        "6edccbaece80ca49186ac727770008f817d2744f1206760f01e609d0e5408b76"
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

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
