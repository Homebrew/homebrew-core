class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.31/threadweaver-6.31.0.tar.xz"
  sha256 "4a65944dcca12672ace6d54a48b3a993d4b46b6095106316c3a95ecae6af9906"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "305546048e7e96940a90805f8a8585ce3b117d3b10a2d882a4a247b6ec01c9f9"
    sha256 cellar: :any, arm64_tahoe:       "336299469231fa5c74773529683b1451d5764491fa35b904ad59d577ed300fed"
    sha256 cellar: :any, arm64_sequoia:     "610cb982a1e5ba60855deb90a5ac20c09e80b29ffc61c7114f06f191e2a71508"
    sha256 cellar: :any, arm64_linux:       "08137a3c8340eb51ac233b8a6d1238474cd600388daa74d27c3f524f9a9ccccb"
    sha256 cellar: :any, x86_64_linux:      "f775ed346b48760135c3485d2e54ba11bdee8c42bf9416aa4ab103b8976f6130"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qttools" => :build
  depends_on "qtbase"

  deny_network_access!

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
