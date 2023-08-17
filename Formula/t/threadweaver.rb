class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.109/threadweaver-5.109.0.tar.xz"
  sha256 "7274529540c4f478519271655a409e4d89c297683eab531a764cf2e5b8c2d2e0"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "48a0b55d59a6eef08f01dbd4ddb95be356a0cb272b53e0ae108eb5f39cd0ff1d"
    sha256 cellar: :any,                 arm64_monterey: "79456d08d9c38aac19ec20cc36dd460bd43aa6bacf5e86ca256cccf44930c399"
    sha256 cellar: :any,                 arm64_big_sur:  "c25f3e4b35f5ae1eaf271ca24e144095ae25807691db2c476964bf6ce27696e0"
    sha256 cellar: :any,                 ventura:        "3d6c3b94326cf00ce77cb73b23876aa3aba6fa0ae087af5c48f5b4bc77f119b7"
    sha256 cellar: :any,                 monterey:       "cf4653efaf70faab9b80868c35ced3713750cff11b207caa04eb9835b657a655"
    sha256 cellar: :any,                 big_sur:        "2c591902b509752f6980682d76d98138de65fb86df920909e0c8a2e0370fa296"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "861f24f2decaa102f23e2fac40e48625fd0fbed5d87888616a15ca93260d40c5"
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
