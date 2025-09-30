class Xlearn < Formula
  desc "High performance, easy-to-use, and scalable machine learning package"
  homepage "https://xlearn-doc.readthedocs.io/en/latest/index.html"
  url "https://github.com/aksnzhy/xlearn/archive/refs/tags/v0.4.4.tar.gz"
  sha256 "7b0e9db901c0e6feda4dfb793748ec959b2b56188fc2a80de5983c37e2b9f7d2"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 sonoma:       "7ec1cd645264843122f75e157e366c1cc0ef84be1b8a4a0d3705d9e04619d256"
    sha256 cellar: :any,                 ventura:      "c0ecafbd0f8f1103d6a01ff267bb86a11ad8515a4421acda57ff9b2c0d33250a"
    sha256 cellar: :any,                 monterey:     "36bbe9dd0cc0deb15f9bca3a0f8db3da4e57cf4c62f3cfb2138b5bb88f7f4587"
    sha256 cellar: :any,                 big_sur:      "a28e91b107a782fe4bfa9894ba647a36ed7669f25978bc0cec1ce25627d19b6d"
    sha256 cellar: :any,                 catalina:     "4edeafacfb2f12dabd7fa08bb60d62186912c6e000a496fd5bf31523ecaa3557"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "988336d4ee9d33798bc18e46135225033cbbf083aada8ba0e7bdbfa968718229"
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64 # https://github.com/aksnzhy/xlearn/issues/354

  on_macos do
    # Can be undeprecated if upstream decides to support arm64 macOS
    # https://docs.brew.sh/Support-Tiers#future-macos-support
    deprecate! date: "2025-09-25", because: :unsupported
    disable! date: "2026-09-25", because: :unsupported
  end

  def install
    inreplace "CMakeLists.txt", "set(CMAKE_INSTALL_PREFIX \"xLearn\")", ""

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_MACOSX_RPATH=TRUE", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install "build/xlearn_train"
    bin.install "build/xlearn_predict"
    lib.install "build/lib/#{shared_library("libxlearn_api")}"

    pkgshare.install "demo"
  end

  test do
    cp_r (pkgshare/"demo/classification/criteo_ctr/small_train.txt"), testpath
    system bin/"xlearn_train", "small_train.txt"
  end
end
