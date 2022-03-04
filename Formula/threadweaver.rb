class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.91/threadweaver-5.91.0.tar.xz"
  sha256 "22485000cf28d4b28a46e7856532339df5e3e49180ee4a0493f3f3491f9e00a4"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "a5158cf0b870ba951db1f3f2b50f35d41d925173f1d41b7c1dd073de39e3adc4"
    sha256 cellar: :any, arm64_big_sur:  "700982fb92f7a0c85ab1048a79250b0e4ddf395a83c685e6c1867d7bbab7c5c0"
    sha256 cellar: :any, monterey:       "d48ae460bc250d1314b2713308df1cb155beb7a8e629831c9395d6d132d8254a"
    sha256 cellar: :any, big_sur:        "b31e8ec013eba219feb3dcc559f0436473192af61650988720e61d02e113b7dc"
    sha256 cellar: :any, catalina:       "778808ce5c3ad1f3c8c834e37c4bd0d562b404bb37bcec3e736a8107add3701d"
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
