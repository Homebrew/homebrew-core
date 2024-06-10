class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.3/threadweaver-6.3.0.tar.xz"
  sha256 "81201f8f9918d6967b76a5c8c468481289e5bf56351b3e140cce532821f7d913"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "78f249d75544ca0500d634c40346e2c32ee50382872f7a70331e0536dddf517c"
    sha256 cellar: :any,                 arm64_ventura:  "fffc9bc6aedcbf87e6ade2acdbab0b8811f440157131f462d5517e8e9790077c"
    sha256 cellar: :any,                 arm64_monterey: "d64e54efbc938059ca5e0f8b61b7b3ac800fc021118873b5186d5f62990b1df5"
    sha256 cellar: :any,                 sonoma:         "7136d20679165d45653172b976054130f1b125f93a79009e9bed61c68165614f"
    sha256 cellar: :any,                 ventura:        "7dde615bcad4269c2d0bde05023b53ddb189b064bcc374c552a3c84c18a4d1dd"
    sha256 cellar: :any,                 monterey:       "37b494f7339daec95626fec2650e7b2336da59aa8700eea5de1e87cd34d3f4e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73b68670c5a1bd82c1412f57259c821cfe356f10284927b96a6d36faf740bf25"
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
