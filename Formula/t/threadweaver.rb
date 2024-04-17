class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/frameworks/threadweaver/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.1/threadweaver-6.1.0.tar.xz"
  sha256 "dda5d5508d61707eb4cbd044f371e34480ff2f44381adc4cd1b703cf4e458dc8"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1476090a37e770f6746e5decc765222cf5d378a24546691d3bee7510ec201ab2"
    sha256 cellar: :any,                 arm64_ventura:  "3190d1b92dc4bf6c2303455c81756ce6fcf1079767cc5cd7dd0b41bb08bb4dbd"
    sha256 cellar: :any,                 arm64_monterey: "d5e771ed7ffcbc8e57532a993e3b7fc1d0eb33d52e18e2100df6ea89a374eedb"
    sha256 cellar: :any,                 sonoma:         "d2b5957cb77a92dde9d469adb0fc15fe12eeefe9d7631698dbdbb493a609ba4b"
    sha256 cellar: :any,                 ventura:        "9bdd7373fa396bfc4b2350827b816b153ff4aa2f16530aa1c28953efae3823e7"
    sha256 cellar: :any,                 monterey:       "99212aecc2fbbd9c3ce71c1b068bfce1f4a58e1d02f4bd7c0b04558a0a190476"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "833ce947a7611350795806798745580a72cb2c014681f35c9964e1251923a653"
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
