class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.105/threadweaver-5.105.0.tar.xz"
  sha256 "97c64a0bbdcc40cf9e374342db5062b657a18dbcf097976d94c2eb31955186e1"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6616dbe976b6507b438546570d3329a6cc161444d488c9460396b4291a73997c"
    sha256 cellar: :any,                 arm64_monterey: "48b272f5057b2c1ba0b55ad6c01729b50084f238aca23a91783faa17e6854b6f"
    sha256 cellar: :any,                 arm64_big_sur:  "c277cd8ba0b2f5a1fc9dc89eecca46a6ad514569cc6b6e9000f900a232ca4a9f"
    sha256 cellar: :any,                 ventura:        "5acbfbeeea78c6a74457b5deb3ad5b4a9fce9bf61bef28eb640fb56c7a26ee86"
    sha256 cellar: :any,                 monterey:       "82bba1fba8a9c2a6a038c82db4541ee2fccd4ee5b2236ab3f68a4b5a18c6ed0f"
    sha256 cellar: :any,                 big_sur:        "2e98afb3a9b57c690b3b7c29e211c2074c488c53eeff742c4f6e3274e90d182f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b1ef7b4e9d0df2082619650fa12c6161a2b1649b70d0a754f44218e01680aa9"
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
