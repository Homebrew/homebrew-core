class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.29/threadweaver-6.29.0.tar.xz"
  sha256 "0d61797f9400acea7c94a0998e21954685f2de0b2c57760b85186560819fd5cc"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7e086e70d89345492c037f70cd7dd3c644b467d4b71f5495770764a00707ebb2"
    sha256 cellar: :any, arm64_sequoia: "0255a638cca38befc775e2006da5bc5f003cb5c314f9770a2e0a47ec902ffed7"
    sha256 cellar: :any, arm64_sonoma:  "e25ab3887fba44e1bea0c72d84847c5d5ed051b27664ba819e0dec34a31e9b72"
    sha256 cellar: :any, sonoma:        "adaffc30340ad3aa7078f9bec5c4fd0edb4a74fea6345e113f721bc05168d832"
    sha256 cellar: :any, arm64_linux:   "6f214403a2a425ae7fdd21320950aa7cbd740a61063439c3df916532bbb6fbc3"
    sha256 cellar: :any, x86_64_linux:  "1dba4a03c99ddd8d748c9e33c88b6f2fb1c556deac8ec7b23af3c929a1eb6a57"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qttools" => :build
  depends_on "qtbase"

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
