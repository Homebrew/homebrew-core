class Xlearn < Formula
  desc "High performance, easy-to-use, and scalable machine learning package"
  homepage "https://xlearn-doc.readthedocs.io/en/latest/index.html"
  url "https://github.com/aksnzhy/xlearn/archive/v0.4.4.tar.gz"
  sha256 "7b0e9db901c0e6feda4dfb793748ec959b2b56188fc2a80de5983c37e2b9f7d2"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c4ec883864c2f54e1a9f3ea3367ad2708279dc237865e9d8c99663f91a93226e" => :catalina
    sha256 "46810065f0738f93158ca485a22c61625f5d86272b7f9e3e97f3286affb4f775" => :mojave
    sha256 "41cd07c71a598ec5e1a8c458352f7570344822a9cc4b98f0327fe029806d3db8" => :high_sierra
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
