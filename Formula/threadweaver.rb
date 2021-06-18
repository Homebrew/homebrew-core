class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.83/threadweaver-5.83.0.tar.xz"
  sha256 "540ecedea40f1dec1fdda76464a2a610de713b03cc86f06c7245f307a1b2098a"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "199d668ef3fb2217baf72c1ea0d61777befa73760adf73bf1578e4806d82f998"
    sha256 cellar: :any, big_sur:       "3622de43f8266031b374c4bcba2f68c0c04f9ca7ba99515dac68466c297f3656"
    sha256 cellar: :any, catalina:      "3399ae41305e9b10449b22ce34ff00f236125b005cf1c4bf9fa249359f4ad733"
    sha256 cellar: :any, mojave:        "8a978cb6c7423f0c40162403329b9e173ac805136fb8bbbf804c7d965172f800"
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
