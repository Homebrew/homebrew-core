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
    sha256 cellar: :any, arm64_big_sur: "ab63e8e0f342315945f3f44851abea4b9d6258041a2f8c93f02859fdc036deab"
    sha256 cellar: :any, big_sur:       "3292d7fc2cb4932bd0fbda38d510c3e3e37c0a2007f822e912da164a4f2a17bf"
    sha256 cellar: :any, catalina:      "dce58a4c3a347fff98c44a20ea89f7d3383f3e2126bc60284ebb1f335cae4723"
    sha256 cellar: :any, mojave:        "6c2bcbafdb3a3e98ebff128ff609a4ce748bb6ad3bc7778964877dd97945af3f"
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
