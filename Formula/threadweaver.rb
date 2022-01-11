class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.90/threadweaver-5.90.0.tar.xz"
  sha256 "e3fd3815b1732e5157d5d7ab2d27dd447a8d60ff50019ae9f0e5665b3ffd30bb"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "685d570a49809a4436b5f16cee6f23f72cadf847ed1b403c49d9603e8d826ea8"
    sha256 cellar: :any, big_sur:       "37a596b4ffeec3b957521d6eb4e5d57f60e930871739b7fa5e36438f82e9d0fb"
    sha256 cellar: :any, catalina:      "4e4e4da2a10f15ea27dbd31a7cdbadeb372fd97926b63b1e4271cd834de088c7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

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
    qt5_arg = "-DQt5Core_DIR=#{Formula["qt@5"].opt_lib}/cmake/Qt5Core"
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, qt5_arg
    system "make"

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
