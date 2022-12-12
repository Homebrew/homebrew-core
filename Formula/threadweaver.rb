class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/threadweaver-5.101.0.tar.xz"
  sha256 "4fd103c528590fa974f267d6de5a709b942cee15247b3d877f27d997ff62fbfb"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2e7acd0d398881f1a81e5cab926f664b9d5bdc1bc97136baf309fc70d7dbfff"
    sha256 cellar: :any,                 arm64_monterey: "501c688d64cab94db09770bc0c7e227ec28ec1d05b6f81881690d234acbab162"
    sha256 cellar: :any,                 arm64_big_sur:  "bdcc16b5e89d5773802472bf138a86e88dbf6530c56cea14003f956c4be359a9"
    sha256 cellar: :any,                 ventura:        "6ec45ebea4695f1e2685d3a11237d4b4b71144a60e051516d4bb052839ef65da"
    sha256 cellar: :any,                 monterey:       "f785ec1206fb45cee8e9703914b87e51ae01eccd13fba5842111b6e970e37781"
    sha256 cellar: :any,                 big_sur:        "c019c85b443d1a3b0b17d1801875a20dc03c5d63e7dc21fd045b55495b885294"
    sha256 cellar: :any,                 catalina:       "f2acb8afb1d5bca9ba99a24a8ba0237717c9d738c21a00da388e1f3c3b8ebae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd84ff2afa8e76448b39208bc814749597a989b466f9a17ffbc8fd4f867cdc71"
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
