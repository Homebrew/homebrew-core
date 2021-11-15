class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.88/threadweaver-5.88.0.tar.xz"
  sha256 "b2f3079158a52c8e49ea0989e18a509dc9693f6a26f0739b133bee0f4b02df1f"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e5077b92fdb517071fa4c253fea59fa02b19c3e4ed2d1b3f7a5c46a6f8491b19"
    sha256 cellar: :any, big_sur:       "de345ab5238155bd6510b4c3f7a65d122a34222aef0e755f3d3d5f70b9ad0d14"
    sha256 cellar: :any, catalina:      "051c4fe369b3a285e5c348b03b926203eb6e0fc42b0086ba9e9a62b04dc15032"
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
