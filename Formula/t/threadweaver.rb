class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.5/threadweaver-6.5.0.tar.xz"
  sha256 "ae70d0936c438ebf4a3f7b2a708efb9cd30b5a4147d9b70ae5d4437dbb20bde8"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4bcd95e5f5b41f0a192563575052a9c533bcc546e142b03ab4dd0de493179a17"
    sha256 cellar: :any,                 arm64_ventura:  "f17a9c1259a883edec4c720eafc15ff4b93ac1d5c43a078d4cfa4980f6b3ae76"
    sha256 cellar: :any,                 arm64_monterey: "cadb81c5c4d811cbe5cd4682700c1c4b6d6a1984bfd9fcfc330e18dad9c3eadd"
    sha256 cellar: :any,                 sonoma:         "84a4148813880b6a3583d2099c89c65eed42dc92914df4dd95431ac7ea8e2fb1"
    sha256 cellar: :any,                 ventura:        "3f202e7b3a8f1d6b8f0d8054f0b341bfc0fa2bd3b38a14796bbc3828fda7683e"
    sha256 cellar: :any,                 monterey:       "1a17e236073902898da419b7752b63d064e0d6187691616ae101c899c6ab03df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7f4f164121f6aa2907641a9488cc6c1abb88edfbea1b736a1515fb9c88b43fb"
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
