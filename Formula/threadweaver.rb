class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.94/threadweaver-5.94.0.tar.xz"
  sha256 "87d8431a62c53b7e433b49dfad4fd6cacb58356a50cfa17ac480c6bb00a8e1c5"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3a064017b3c97a14d389c6f23183f64858bd7cf365f4b945f53397f2aad60341"
    sha256 cellar: :any,                 arm64_big_sur:  "af3085aae07907f34337cc0acdedad14ecf833d9b2f8b738cbd1f233e0bf8cbe"
    sha256 cellar: :any,                 monterey:       "f4a8042fd390e91e1aa72e62c8fb87d78abea7897df97f391faeabd63040e7f0"
    sha256 cellar: :any,                 big_sur:        "2de94ea952e24a855e1bb6ead55a1e0f69bb680136f1ed66e67046a7f1e89aa3"
    sha256 cellar: :any,                 catalina:       "1ac1f720dea0b1134308fb3b332bb67eb743c3eabaeaca5d6a48f6f52cd21919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80d5933462e16f06004e36c5a09f24014ad79b6feae32b85f35bae6ef9490ca4"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

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
    qt5_args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{Formula["qt@5"].opt_lib}" unless OS.mac?
    system "cmake", (pkgshare/"examples/HelloWorld"), *std_cmake_args, *qt5_args
    system "cmake", "--build", "."

    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
