class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.82/threadweaver-5.82.0.tar.xz"
  sha256 "d5da9c6079deef0099f0b84d1fb31a388dc7bf4349dfd08df7baba1632251bdd"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 arm64_big_sur: "780d8169001746aebd3f1bc641831ebf85153916260e05ce9590f1bb4208dddf"
    sha256 big_sur:       "b425d56b3db2d77acfc2f67bdc272b4cd4ed3a8acc1efca0ed439a4fbe7f48e7"
    sha256 catalina:      "373ba72a3afc1ea493428fd5c2aa009c7b5a65e2276f20ece3b703963c5393e7"
    sha256 mojave:        "3a641b043ba7eafa49b23d51e6a125959b2b8555a159d311d57a5c3a2d82a9ae"
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

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

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
