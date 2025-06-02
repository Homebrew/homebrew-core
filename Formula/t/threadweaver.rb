class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.14/threadweaver-6.14.0.tar.xz"
  sha256 "a8f71f7e69751e36dbc7fce9581f55b66844bc68df6af2e8a94c22c8fe9870ae"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "db99103e12c52aa1baa725a84329513887518c445cb9077bd2e351ad64ffbff0"
    sha256 cellar: :any,                 arm64_ventura: "4329f62cbe8f7a8f10d206a07a72933e87f462891130454c7b8658ea41f6ac32"
    sha256 cellar: :any,                 sonoma:        "a9de67fc538a6c36e6df6161d80ed51046a4ba85be4f4a75c41872f930bebe62"
    sha256 cellar: :any,                 ventura:       "3eb5bbfe73a9e135e78d047d7f91d733d45f3ebd6399cfa821110888235d3376"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c179eda9421fe0b32826fe9499efead7588d0b273d69751b87f04fb2d00cf20d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_QCH=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/HelloWorld").children, testpath

    kf = "KF#{version.major}"
    (testpath/"CMakeLists.txt").unlink
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(HelloWorld LANGUAGES CXX)
      find_package(ECM REQUIRED NO_MODULE)
      find_package(#{kf}ThreadWeaver REQUIRED NO_MODULE)
      add_executable(ThreadWeaver_HelloWorld HelloWorld.cpp)
      target_link_libraries(ThreadWeaver_HelloWorld #{kf}::ThreadWeaver)
    CMAKE

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
