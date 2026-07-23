class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.28/threadweaver-6.28.0.tar.xz"
  sha256 "ab4a7e1a2ff4ee9e3ebb73097fb93beda6857f08d1c4ab7d15af17c383ffaf7e"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e59facda66442219bde8daaac49d56b3682a65410cab527dd951324de8553f09"
    sha256 cellar: :any, arm64_sequoia: "1c976141514a58b9a147bd9dc96824a2d3386a80ffe92d3bf6fcb284ecd1f166"
    sha256 cellar: :any, arm64_sonoma:  "1f7f0578935c58a2448a78b76de51f594add49da40f034be03c1f0b11947ebbe"
    sha256 cellar: :any, sonoma:        "226a7e2568ed45444f4848bae489d9b53f539bc58203a94c23ab78eb63ae65a7"
    sha256 cellar: :any, arm64_linux:   "70ec743ed25952bd0c9337f391815cbf8039323a0f8b044826fe2f7a5d661709"
    sha256 cellar: :any, x86_64_linux:  "000574a5e0761415b1e76cb19173cd4637504b55699e1c146410a9b38fb80e8f"
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
