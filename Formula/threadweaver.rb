class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.106/threadweaver-5.106.0.tar.xz"
  sha256 "78433646a26f2ea6cab82ccf8e177a46089c77306026ef36a25caea20a161ef6"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f84222344074d83a89a5059b279d51155430e31eaa7353bd4140535cbbda3928"
    sha256 cellar: :any,                 arm64_monterey: "1d51aafa66339c2623239e3b488f106ba672531cc1e90860970328d00f0864e6"
    sha256 cellar: :any,                 arm64_big_sur:  "41e3d93608fae5fdafff35f06aa78f0843327b5d3dcf21ca11686065d2884af2"
    sha256 cellar: :any,                 ventura:        "a8d822b5a629105a7873655c63316629592eb3ceeb281261d1cc685644ce3678"
    sha256 cellar: :any,                 monterey:       "45cf6f83b16ad8789c34250c4b3e2b474f887466419ba822133b524feb409d08"
    sha256 cellar: :any,                 big_sur:        "e0f7ce1ac6c8a1ccbabeb11c0ade378a7869ee3f13bc4f31ec61b437e52b58d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "266b0cd9234bd2f5d73fd6e56dbf94c6b5985971d944971f370eab2d600f5407"
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
