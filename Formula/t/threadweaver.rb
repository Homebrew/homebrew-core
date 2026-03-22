class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.24/threadweaver-6.24.0.tar.xz"
  sha256 "aa7608961397e7cdbdc8362ae9d1eaba6c5ba9dae3a84c11830fce155e5ed46f"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "96634fc1797cfdf0009c510fb658d620def83bba93ec617ff53669ce3e304ac4"
    sha256 cellar: :any,                 arm64_sequoia: "3a4817cbd6068e9f9d75baf1d8530d02a266a207d65867119857e231a19437cc"
    sha256 cellar: :any,                 arm64_sonoma:  "e889bd2f4a2add16aadde384dd0dc10a980bb2b83dbded04117e5af9a60f3bf3"
    sha256 cellar: :any,                 sonoma:        "3a8a7a60b486730a83767e823365a9696acd3a3f0c9b91d5f6dbd3b41ce640da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5e67903a8c3b5ded64f362ad9f007f6c5b7700bf86fad6d792840de6c63aa57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9444de633eeba91a47b674fd6b4be945e59559783aa7c2cba16eaf5028fe7fee"
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
