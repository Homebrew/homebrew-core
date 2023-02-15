class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/threadweaver-5.103.0.tar.xz"
  sha256 "29bc53a18974758b6af9ab055a148c170b4f8f2e0d7f5be0fa31fb513a47ec82"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "64bd9a36af8aebc0d77ca5aefa16484cfce15b9b13eb6b100f8955efe849a9ab"
    sha256 cellar: :any,                 arm64_monterey: "7b08a332d4431b90c5e99c28db21c309f9e839c7f13e7922bd5a21f9b497bc2b"
    sha256 cellar: :any,                 arm64_big_sur:  "29a8e1f5e741cd6c58a1460c49db2f571f2fd7f68191cdcd6f643ad05804fdc2"
    sha256 cellar: :any,                 ventura:        "abcea47469652fa5544ae7a99e15c2cb02b17c5c6b195f69c700897a38287a1b"
    sha256 cellar: :any,                 monterey:       "00bb63686287cf2a0a559f04d3e3eefa3af99a2226cc07851368236dfd1e9678"
    sha256 cellar: :any,                 big_sur:        "2548642134c41d328980ca1e4db9041d52ba601a3abead2dbf95eae98ad282ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee85ddc011b5caa78641c645d8cb724c8b7f24f809562f9d4366115e37c422a0"
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
