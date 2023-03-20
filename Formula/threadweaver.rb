class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.104/threadweaver-5.104.0.tar.xz"
  sha256 "963decfdf0cf780406eb585efdb213539a00cd16ae4dff2b2ffe8822a609a647"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b34fd5946e7d35a1aad9ee99fd46048bfca5e2ab0731aa97c19298ca6a0e4364"
    sha256 cellar: :any,                 arm64_monterey: "8e06e04eeecad5e44834f86ededa9945fd7654ab6f7449ab7e076706f0670ab4"
    sha256 cellar: :any,                 arm64_big_sur:  "35837b06ffd2970fce28c8c64eab6f6eb234c3f22945da1221bed1689060e3f3"
    sha256 cellar: :any,                 ventura:        "34924bd5a3995934a7b8ee67dbbe72172583918e8d9607776cb1870dfe0e6012"
    sha256 cellar: :any,                 monterey:       "4c275c9324d450521e8a9451d977061b1b51ba2f0dc7cde5c33f71e2118fca3b"
    sha256 cellar: :any,                 big_sur:        "9e2f5f07b95ebb84acecef872352e42fb8774245167208ba5afc9aaf21557642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a452f961cf9b40138adc30eb74c4fde078b506ea351f2a6415ec01accd1370"
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
