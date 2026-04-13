class Threadweaver < Formula
  desc "Helper for multithreaded programming"
  homepage "https://api.kde.org/threadweaver-index.html"
  url "https://download.kde.org/stable/frameworks/6.25/threadweaver-6.25.0.tar.xz"
  sha256 "f74ca31f5559f55870496df5372da09dfb409e197cc6e0f660979b98cd611444"
  license "LGPL-2.0-or-later"
  head "https://invent.kde.org/frameworks/threadweaver.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c5dee61ad3f9244ba6a8a282c12fb77f63568c4ffc006b992e72c78347d24c25"
    sha256 cellar: :any,                 arm64_sequoia: "80ed68413dccdee3d03a941d87f1420aadf60ca8175e73faf373ad5ced09ca66"
    sha256 cellar: :any,                 arm64_sonoma:  "ac5da7282139485f7937f0ebae6d2e71dcb1a97e1da18447cea7da79e828e7d1"
    sha256 cellar: :any,                 sonoma:        "85401e58cf97feddf3ee8c49e50b21bd62e868e47c235b8fc3f021cd27d9199f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6caed4a3b3f4619a392837f8b625cb7f1a636e3081d974b68f10885371e09b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22e62d129a35000e2a5ec95742bbb83afec70b565db9a92fedd00998b5981526"
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
