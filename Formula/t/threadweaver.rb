class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.32/threadweaver-6.32.0.tar.xz"
  sha256 "b3ee9e6cdfdb3dec7c7df8e7f66ace6a94e73a531ba4f1d8f7b74360e7201e05"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1b2a737109308dd9a68d33675eab25addd5cada00aa53d4eb6dc360343b35db4"
    sha256 cellar: :any, arm64_tahoe:       "76dce7506e6d698e4229cdca6ced2686ceecf47ed3f8798caa57c61a5a218152"
    sha256 cellar: :any, arm64_sequoia:     "4c4c4109b5944b1656ab46fb122068df9e2e7bb59d98b6a5cccff5cb9972c98b"
    sha256 cellar: :any, arm64_linux:       "75e95a42069fd4ff13ce4a102b6f1c95f7612dbfb2dd5eba9b859e791a945c20"
    sha256 cellar: :any, x86_64_linux:      "ac2f1c4d5fc4c6ca5c0430d55327aa95b17aa66926c4ac9caa718cb41f8bd4ec"
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
