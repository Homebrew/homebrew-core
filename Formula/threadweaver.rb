class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.98/threadweaver-5.98.0.tar.xz"
  sha256 "5acc0d34e83568a18444537e91eeef93986a8ec3c4b6c326319de959feb591df"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a184df853475e9e195420f9545b5bbb0bddab95b9b38a5d04dbab0f3e0d3f5ba"
    sha256 cellar: :any,                 arm64_big_sur:  "ded9f15dd1ec1cfab7a2f2d754992f166947248149c02565580d6d05b77f9736"
    sha256 cellar: :any,                 monterey:       "32ff54ae8409bf75d46c1866c58324e912519a308f8a418cfb2d8a15b5297981"
    sha256 cellar: :any,                 big_sur:        "f9f0d99750d9bcc80c5f781095b95b0367e20fa4abdb880e2a9ffcfb6de28d41"
    sha256 cellar: :any,                 catalina:       "8534650fab57baefcbc515405b31b0d8337a1855ee019b10d44a8d7a26ec91d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90bf0132b34b1056d83d3d384581a747192842a09cba1bdc323d155ba2608043"
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
