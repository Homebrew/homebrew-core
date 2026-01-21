class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.22/threadweaver-6.22.0.tar.xz"
  sha256 "2f51e312779dc5f592e8def4db225c3c40531d871e8a4d31a8f2a22de2a6582b"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4cfe333da52a5489fccda3ca026050c879698c753cc97e2c8145af3a3337e92a"
    sha256 cellar: :any,                 arm64_sequoia: "5a265ff4f9906accf035f1429b78b895fa20d7d88254fce53e74a5b9eb43cc9f"
    sha256 cellar: :any,                 arm64_sonoma:  "94744ec21ca5163508b71416016cb41b6e9c822ab0018f63b2a3dcac309e1de5"
    sha256 cellar: :any,                 sonoma:        "7451bae8e091c789145f3853bac73f8adf2483303d223dcffd439415566835b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8fc7c4288f6e5877c06eaa673bfda413f45aaf092f30c86de3b941faaea8315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5742a2547542cd9796349045c3e589c20c0315e672900bb32fa9ff5291df40b1"
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
