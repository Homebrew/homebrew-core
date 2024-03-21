class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.0/threadweaver-6.0.0.tar.xz"
  sha256 "ba9daec6e0697fdc2accf74a46a6d59403e5e340d280bce916fd6356a668ddb3"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3fa10fb88c23fea1408ec6c97032052d5a6c39c0afa1ac35d9b142a9a4faba61"
    sha256 cellar: :any,                 arm64_ventura:  "24015af19a5e47df7034743391b80c940e660b89f3114849c080d313351ce4ba"
    sha256 cellar: :any,                 arm64_monterey: "8d27f75f28ce131324f083297a1be661ff6a9ee0c191dcb25f93f393c70b8653"
    sha256 cellar: :any,                 sonoma:         "a6bf1c61359675b78844da28e641fd69c87a00c2f3c1e38d3e222fb2066c38c3"
    sha256 cellar: :any,                 ventura:        "f0f54520ce2d8860ead09463cf464f44cf10c9c5b36a88abb427df36ad37faa0"
    sha256 cellar: :any,                 monterey:       "406b3cdc2b90a7829f1a7cb6d6fe344921cf38f19f0cb0afe0b0fcdbe38cd827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd79fbb29753ee01f620e2e887821dbd3ce7ca0307e5a9069647310fdc04367"
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
