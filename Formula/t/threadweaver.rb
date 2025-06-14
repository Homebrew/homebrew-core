class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.15/threadweaver-6.15.0.tar.xz"
  sha256 "1ae0e593182c25ec8a9ee85777ab767b6c37b0f7e7a6851d4b6d49bfe03da1d0"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "c5dd179c0ea8c845d9d4ab561b7919f5772b04cb443b4d5e2b2d65e67159b9f5"
    sha256 cellar: :any,                 arm64_ventura: "be3cce925fe14f0069437b702db9644bb1a12e15bad04c46939a819a197999ea"
    sha256 cellar: :any,                 sonoma:        "5ec15c300336c413a7dd2c3dc8baa3687593352ea258e20142bcc1472009bdfd"
    sha256 cellar: :any,                 ventura:       "1932a3270bf85b9375d55f3dac90d43ca0a1f2f71425e060f62f4ff7bf2a2a06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5589fecc57ac09501e6770664bc945c1c8f68fe698aa0f3264a80c74771eac54"
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
