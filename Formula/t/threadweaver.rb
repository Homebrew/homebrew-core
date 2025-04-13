class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.12/threadweaver-6.12.0.tar.xz"
  sha256 "ec77fbafbbd9a6bef048e57e0bd64999b1c17b31b43d59a3c5a981ab18f2e1be"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "f11342d3b471aedfb39124270b0e8f03bcd5dd31bd11c5fd5101dedbc61fbd98"
    sha256 cellar: :any,                 arm64_ventura: "c43540e578d384020d4ae8e265cb3584b1115b0d4fce45c53858ccc4f4cb2499"
    sha256 cellar: :any,                 sonoma:        "07481a242f618d870aba6b9feb1a77290b4d85fa5f0b69ec2c54856746bfb76e"
    sha256 cellar: :any,                 ventura:       "c254a6b8c569f265327d725178f871debfd06a074d7962dd7dd14b654bd3b3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8daaa4f6395931012c208731c1e3590ec928acd889334e9bcb404f34c8380608"
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
