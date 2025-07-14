class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.16/threadweaver-6.16.0.tar.xz"
  sha256 "e89d1f276aef77430dd57f7f2e5c195b7201334e9ed114dc24c7ba59430e14b6"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "6efe12ce65efe3f355263db3e6c2931fa14a7eba220dea62412b3ff971732d78"
    sha256 cellar: :any,                 arm64_ventura: "fd1e66557f86302f479581a04ea8c97ea21c18234236e9d1b1742484f0505e10"
    sha256 cellar: :any,                 sonoma:        "aefaf11b58f75b077e8e2d74fb5b1a44db1f2819babcecff1f3ed602ece1c517"
    sha256 cellar: :any,                 ventura:       "617593b433c9fd143baa3984173cba4e21c4677663273d68062a63f2ce92b9cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6555826394150f2b9707c340113447e2fc26b9ef15fa7f6b3b79694aefa8ccf"
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
