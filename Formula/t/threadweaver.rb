class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.27/threadweaver-6.27.0.tar.xz"
  sha256 "6be89d43b4d7cfd4ce519ed24b8bcf8400c93bcfc6f42d9931cd0f852269bdcb"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd3d4fb670cce7f9c6c768f7dbd4e506444780a0d1c40ec46e10849c5b2ad45f"
    sha256 cellar: :any, arm64_sequoia: "6c890db0039dbf655010a2e312d4ff7ee6be250dabaca7606cba1890f37bae01"
    sha256 cellar: :any, arm64_sonoma:  "965b98bf9f384cb24de82d69d5d30ba02d21e9e2b1b4e675bc653b6e49dd7888"
    sha256 cellar: :any, sonoma:        "675e7b0eaefd1bfd2069a4c1919f71a2588ef66fb1e87baa21b051a1ffc7fbce"
    sha256 cellar: :any, arm64_linux:   "a3664cb2493b7e0e2d34b4c5c22258d278490ac68ab479163926e5653d468d7f"
    sha256 cellar: :any, x86_64_linux:  "97411b318b848b504fbdd96139aaf053fe382621496245b1e0403fb8a84565af"
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
