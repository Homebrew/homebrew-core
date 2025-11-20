class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.20/threadweaver-6.20.0.tar.xz"
  sha256 "9313f25a2ea6e2431d34e0b00f68dad6881849c34f1e40515a539a70dd6fbb19"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61b0c940115808a7730051ce44eb597669e76b182070442be0b34ce4e54f57bb"
    sha256 cellar: :any,                 arm64_sequoia: "423f3c8711de8f8e05b5e7711e7a6f42cca5e713275d700df912af751d6f8f12"
    sha256 cellar: :any,                 arm64_sonoma:  "c35a7956efa572d6d538efabfffccf225df78b206f231a21a553f3f5bc6f4238"
    sha256 cellar: :any,                 sonoma:        "7fa2a70b87a5fd14248fc5c41acb5b84792112df566c2cf4e8805f53760b3c80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab61546d302503620175c5710b3b1be837403ee0b433419f6888787385df52e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b883189b77404aa7178c1b8cd76f3af332f56364c7059bcb47c6ce660c1b91c"
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
