class Xlearn < Formula
  desc "High performance, easy-to-use, and scalable machine learning package"
  homepage "https://xlearn-doc.readthedocs.io/en/latest/index.html"
  url "https://github.com/aksnzhy/xlearn/archive/v0.4.4.tar.gz"
  sha256 "7b0e9db901c0e6feda4dfb793748ec959b2b56188fc2a80de5983c37e2b9f7d2"
  license "Apache-2.0"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4edeafacfb2f12dabd7fa08bb60d62186912c6e000a496fd5bf31523ecaa3557" => :catalina
    sha256 "e5f597c563cf3ed1ca7e4ebdc733740b976710730f4388c3e4829552713b966d" => :mojave
    sha256 "738b94f1c782c6bce8fe042bb80b48ade32b909297a0c55bc34004f60b449463" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    inreplace "CMakeLists.txt", "set(CMAKE_INSTALL_PREFIX \"xLearn\")", ""

    mkdir "build" do
      system "cmake", "..", "-DCMAKE_MACOSX_RPATH=TRUE", *std_cmake_args
      system "make"
      system "make", "install"

      bin.install "xlearn_train"
      bin.install "xlearn_predict"
      lib.install "lib/libxlearn_api.dylib"
    end

    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo/classification/criteo_ctr/small_train.txt"), testpath
    system "#{bin}/xlearn_train", "small_train.txt"
  end
end
