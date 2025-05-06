class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.13/threadweaver-6.13.0.tar.xz"
  sha256 "64a162f49fd25263dd992b3e70854b7a7b3bcd15114bb67095bb513c4097e39a"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "d9f0804cba23a4f13fb09083c1a7c89dfc7a979f4c975e4d831c4f4bbaf21a4e"
    sha256 cellar: :any,                 arm64_ventura: "99ecc9ad2cc3b0659040a9e013cf5c83f91d22c978f7f002e5b3e5c136e585b2"
    sha256 cellar: :any,                 sonoma:        "e14a93ea95628016accb0943e694f9d530f07fea55dfe3660bd31e67ca06d9aa"
    sha256 cellar: :any,                 ventura:       "04ac562b04774c9dba77947ce7e512b3df45c3536a0a317c810c4f0ec09776c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40d9ed107f3b7adad5200b2d78965148e5eca8ab6b134b9696fbae2b1569adfc"
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
