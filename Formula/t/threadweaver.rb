class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.23/threadweaver-6.23.0.tar.xz"
  sha256 "d4826e0d8faf135655d15969b27d0fe6fc746a6d308ea34f04bed3de60518b0b"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b07a83177d4c7a50aa4d7a3575cdffb81e0456a1fb894d92b81728c7b774a2da"
    sha256 cellar: :any,                 arm64_sequoia: "ccdb0ff45dc1d7b6bcbed844930e2cabd91d0fac00946c4d1cc0da4852d1726a"
    sha256 cellar: :any,                 arm64_sonoma:  "0e8e038c0434ba92ab78c415c6c349a2651109daca230947ab4270a675e24615"
    sha256 cellar: :any,                 sonoma:        "b0b1b3ce4036ae4ea595d704812e874bfad03013d5c3f0ef3d082e232d77982f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "185be95814862b75174d056b0fb92dcb2e701a04107b10441554b82aef21d4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d241174d7680fbd8de5b7ba5294e92b9d4f00dd734de6283d03add35e8560c"
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
