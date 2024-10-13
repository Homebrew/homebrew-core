class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.4.0.tar.gz"
  sha256 "61f873ec69e3be1b99535634340d5bde750b2e4447caa1db9f61be3fd49ab1e5"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "31a5101ac333638f0b5ea2a2d3a7a40c0ff9a235a038158461cab52666a8f8f0"
    sha256 cellar: :any,                 arm64_sonoma:   "1ba924051fcd614b0841d704d8302233611aad0e5981657424e0ac16f1cdd6f9"
    sha256 cellar: :any,                 arm64_ventura:  "56b147b011c79a23b72746d5e8bf186e86e82a13799e473f6c72921b15ef4622"
    sha256 cellar: :any,                 arm64_monterey: "c99036e412ed1c672a2be4805edfe156f1446255f7394e61a297bbc1589aff19"
    sha256 cellar: :any,                 sonoma:         "600311045d5469c75d84d6b3aa7161c085bcc3c862c7e7421e7e157efeb3f5bf"
    sha256 cellar: :any,                 ventura:        "a16422ec4d0f554a78e5d8ca08ee7b979770361772bbfd18d8a096d4bed8ad0c"
    sha256 cellar: :any,                 monterey:       "dd492a06f46d931a677984e2663a62c70be6bb99b28f4a0bb8d573b3fe8259b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689bc7cdc7b5468f779265c66b4140ad911ea6bac85dc1df33bb64a9b7fd0f26"
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
