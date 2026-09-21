class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.30/threadweaver-6.30.0.tar.xz"
  sha256 "e5400968a41820393e76190ab5dbb276c09513263d1b185d64b40f82dcd9b457"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "48d31fc5a217cf04c3d87e83d25afef138a6bab8c39b829686d4f5f7f08b96b2"
    sha256 cellar: :any, arm64_tahoe:       "cc60f7f9b233c553985edb00af7f8ddbe518d6c7b3a0951daed4f9e03ba14154"
    sha256 cellar: :any, arm64_sequoia:     "66b2964be4c0ecf8e2d10a53fcac94129d5ef2412147fcfdcc054eba1ad3ac1b"
    sha256 cellar: :any, arm64_sonoma:      "d98fe99c5dace6832ff235c8ab322e97f71dca818e326a76d27c60c3b3603989"
    sha256 cellar: :any, arm64_linux:       "b3314de660662fe0aef08cba026ff0e86c477c89b4879e4a33854f9c9edb40f0"
    sha256 cellar: :any, x86_64_linux:      "3aab78e0e1a753f33fa699984f603bab1c8d7703ba153532245139232e562b39"
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
