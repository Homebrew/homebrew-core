class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.18/threadweaver-6.18.0.tar.xz"
  sha256 "a6e7f4c90b9b9304ef67a0fffadd77655757c65f7bee00c35b38aefc869e3278"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cee3bd055c497f8215738ebd65425e45d928cb51d3a562864210768f7b994dc5"
    sha256 cellar: :any,                 arm64_sequoia: "51ea181e49d8d00d0587d76cc3e24c9375d8c7ab5bf7e45d50d94b658861bf0c"
    sha256 cellar: :any,                 arm64_sonoma:  "015498d490fb567d684bd7079e3a9d171a49c599d0e038bf645a1639f65d9dd4"
    sha256 cellar: :any,                 sonoma:        "8f28fd5d49b43c66c9be147a7be5ec0890add755d818244d3072ca4566f3499a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc4a24f98d2adc04c9cbf609241057724abdef334bd15fd1bd7a4943a2dbbb7"
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
