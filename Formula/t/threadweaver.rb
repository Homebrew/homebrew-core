class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.26/threadweaver-6.26.0.tar.xz"
  sha256 "ad32daeafac62077590885f3abc4bcac1abbc6faeb34c20b32f6040648f7de1b"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "627c4c8885115f8425b66378dbd1e6879cfaaa852d294b332717697791382dae"
    sha256 cellar: :any,                 arm64_sequoia: "600d4c43166fdf04b0fedfbbe00bb5ab3414234e5421a790584cecec91f71239"
    sha256 cellar: :any,                 arm64_sonoma:  "4226dac613e03263fb8c173a4a4fd3e1580686cc9b6d52a0286989b194ddbd47"
    sha256 cellar: :any,                 sonoma:        "6f482400682d0ff515c958f13b4450ef97bd242bff2447e6cf8a911ccc5da38f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d60cfb3c94f90563eb26e784ac6f032ee0854a59f57dd27d2c227d3eb7983d60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "add6d78c8241ebafb773fa08de3d20ec0d03a6fa23822fdac9feba8798650cb3"
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
