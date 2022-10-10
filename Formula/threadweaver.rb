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
    sha256 cellar: :any,                 arm64_monterey: "bde4d7bb458e69e5d0fd38bfeade00c230be58d412480516b68d31011f93ce12"
    sha256 cellar: :any,                 arm64_big_sur:  "fffe9ec54d3204120f76b1727a39f795ac83ddd5af01c0bf1b0e7e1c37ac282f"
    sha256 cellar: :any,                 monterey:       "a56fdae4ddec022222939e212387d51956d5634a79a6bd7adf1664d9fe543ca7"
    sha256 cellar: :any,                 big_sur:        "dc19891af582cb189c3f8c0558301a15584ed50d2b3560e35aacb98c2b70a428"
    sha256 cellar: :any,                 catalina:       "0156ad22f345cc8a40e64190ce719785cffdd687364c65b6d60d8732414606b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92397102fecc48c933f6236abd5be6ed256dce7437570481a9444ce7bbeb4a84"
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
