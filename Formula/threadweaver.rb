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
    sha256 cellar: :any,                 arm64_monterey: "88042d3a4e7cbdb83047c4be6012010e9cd1f41eb8b75f7cd2b610c522925de3"
    sha256 cellar: :any,                 arm64_big_sur:  "56d64afe72182837d2bd78c9aa6c091f3a5204bd889a14224b85249f13373037"
    sha256 cellar: :any,                 monterey:       "8fdcb18083c7b95b3b2cbcbe1b8be0162843258fc1d7e43429ba25cf6922887e"
    sha256 cellar: :any,                 big_sur:        "86fbb3fc66069d8a8c1da09f2effd22b609c02b174405b5e477cc141f4c42258"
    sha256 cellar: :any,                 catalina:       "467601f5a2ab88a728e04cbeb489259d5d0f42f42ac639696c7f5c8b04e28683"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69660914f3c216895b74b6189c444f663997ac598c0e6e99e99bc7da64d53bd8"
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
