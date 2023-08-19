class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.1.tar.gz"
  sha256 "b3779627c2dfd31e3d8c4485962c2efe17785ef975e2be5c8c0c9e6cd3c4ef66"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59410a24631f195f51044c59046086396e5ef52b4c521dbd6112af4df5c8bf79"
    sha256 cellar: :any,                 arm64_monterey: "7dd2b62d07c9185a2c6669c8ec623751c974a074d15ed678f44aca782d72d797"
    sha256 cellar: :any,                 arm64_big_sur:  "7a5c987579c9144bcf3da8cb8404f8b7f8c17dee8c60cdb61c029413930b1c74"
    sha256 cellar: :any,                 ventura:        "296ea3254aa001b93e232b1c930b5cd3c46eac776b1712187085db4de61d694c"
    sha256 cellar: :any,                 monterey:       "560213b626ef622d997789a0f58b0117e4b9f0c80cba33375920c3dba13494ac"
    sha256 cellar: :any,                 big_sur:        "fa7d51196ee4ab61f2526cc0c99d00353990c8e15bc413dfe4c173eeb4cc39d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0c8a46ec725d2e233989490b60de2f66bc635872aeadd2ddafb2fb680bee54"
  end

  depends_on "cmake" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "-S", ".", "-B", "static", *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF", *args
    system "cmake", "--build", "static"
    lib.install buildpath.glob("static/*.a")
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
