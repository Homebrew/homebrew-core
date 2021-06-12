class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.83/threadweaver-5.83.0.tar.xz"
  sha256 "540ecedea40f1dec1fdda76464a2a610de713b03cc86f06c7245f307a1b2098a"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "81d4390938e7398e9d78e31f8a14a5db91813d30b91a77c7e8c7c85a5665bc8a"
    sha256 cellar: :any, big_sur:       "c47bf29a0e22eb0a5910e4d869840f5ba4747c2befa1beafb46df47c08bdf298"
    sha256 cellar: :any, catalina:      "fc78c0c52cd4f00c2e056337425321b8b2a195b1e9520fc0d10ae8f9bfebe522"
    sha256 cellar: :any, mojave:        "493aef2a49d5b480f2ee75bb94a78ec854d533154e9140b4a8b1f4718855c50f"
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
