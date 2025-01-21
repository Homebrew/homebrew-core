class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.10/threadweaver-6.10.0.tar.xz"
  sha256 "136a636a33ccfa9a375a2e1ee503760a0a910002b972be0eef20352eb106bb84"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "a85f767949478bf2d351084e47979f3ef9d5083d0bcb895c63f5ea2cccf9aa6c"
    sha256 cellar: :any,                 arm64_ventura: "21dd03ed3850c56dbb1e32647958b2463e3aa390b363e054a202e65c44d64e78"
    sha256 cellar: :any,                 sonoma:        "89fd32a86527a4d065b370c6ab1b280e8204f540630e474217b53f20cc76fc98"
    sha256 cellar: :any,                 ventura:       "4d466f4be379a5b34289c5627e9a6c749b31558ced4d28d6f4cfbd8272afa753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc3bb2cccf0f7731de38d651c9797631e6b11789204a37904591c1dcc50aee2b"
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
