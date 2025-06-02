class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.5.0.tar.gz"
  sha256 "7d6fab70cf844bf6769077bd5d7a74893f8ffd4dfb42861745750c63c2a5c92c"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  livecheck do
    url "https://developers.google.com/speed/webp/docs/compiling"
    regex(/libwebp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "700e1f0c8a32f99de402e714237c786191c5ef782b8639b2f2b1c5794b025825"
    sha256 cellar: :any,                 arm64_sonoma:  "121c8d526d62724c65ca82ad99a2edfa56bf7aeb6a69a231399e0faab96cad1f"
    sha256 cellar: :any,                 arm64_ventura: "a0ce31323770314c805a305cccb2e30f2a0f04d461842448de9d569f5baa6306"
    sha256 cellar: :any,                 sonoma:        "18e9cdc6a27311b71e215cfc392f4d2b032a8f9f43b80b65dc920ed1bccbbc34"
    sha256 cellar: :any,                 ventura:       "6df9e02a753aabd2aa0a1096ad30a2460ff87c86e8bb0b9dd0562cbd74c03bb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44e567d1e031c4de42c3a28df42a2a46a09bef581606b49c1ce19c6496b3d3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04808907272edc079436cb1e6cec57021d17007d0df49842158865e2ff48f601"
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

    # Avoid rebuilding dependents that hard-code the prefix.
    inreplace (lib/"pkgconfig").glob("*.pc"), prefix, opt_prefix
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_path_exists testpath/"webp_test.webp"
  end
end
