class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.7/threadweaver-6.7.0.tar.xz"
  sha256 "1ac3fc8051f31ac4f76dfd5d157e5c375d183bc0762152a44e1831cf5816a956"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "7c604c340eb5dec02c2ae95ea12d652292d034f3c037f4be741f300c584e56a6"
    sha256 cellar: :any,                 arm64_ventura: "26c4653229b79c9ebb1e133b80efb98dd0026d32069b7d9a700a7204725d7c74"
    sha256 cellar: :any,                 sonoma:        "e1cc2d1f8e0d2cf334b441eded0bbe40cf6191d68ea08bff3ced8afd74dba383"
    sha256 cellar: :any,                 ventura:       "224124513a52af47db2c9104a4b603d6f31df4f7436f839f30a9bd30f2dcdc5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "834ccd2b870499ac69572fb53bdf09af20a28ca82646bd6f4a359e92c9dfe0c7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "qt"

  fails_with gcc: "5"

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
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(HelloWorld LANGUAGES CXX)
      find_package(ECM REQUIRED NO_MODULE)
      find_package(#{kf}ThreadWeaver REQUIRED NO_MODULE)
      add_executable(ThreadWeaver_HelloWorld HelloWorld.cpp)
      target_link_libraries(ThreadWeaver_HelloWorld #{kf}::ThreadWeaver)
    EOS

    system "cmake", "-S", ".", "-B", ".", *std_cmake_args
    system "cmake", "--build", "."

    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_equal "Hello World!", shell_output("./ThreadWeaver_HelloWorld 2>&1").strip
  end
end
