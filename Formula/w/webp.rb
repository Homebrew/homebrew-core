class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.6.0.tar.gz"
  sha256 "e4ab7009bf0629fd11982d4c2aa83964cf244cffba7347ecd39019a9e38c4564"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  livecheck do
    url "https://developers.google.com/speed/webp/docs/compiling"
    regex(/libwebp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11a19ac5db13a8485d4d6f712d65d48531f99e8d7237407ab42718777eefacb3"
    sha256 cellar: :any,                 arm64_sequoia: "ad74e4538a799bc21e85fb2899c2267f7b6c8761212d195ec3cb3583062ad19e"
    sha256 cellar: :any,                 arm64_sonoma:  "2c0172632efa4d17103aad0d82dd27addce7db290b5cf52cd9afcbff3c39a497"
    sha256 cellar: :any,                 arm64_ventura: "984de8caf92ff3492d12b9c0afabd97e07139f212222021a6813a2c99f66855d"
    sha256 cellar: :any,                 sonoma:        "ea4e1ab3ff7e848a8b26a6e851e032887c0a5853d4586e77e98ca586b7f96a35"
    sha256 cellar: :any,                 ventura:       "f5fa0476d932c52eedee49bdfc95d49514a6816f38c479cd8732a866e44ee3b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d8b90c79d3e912e86136a88e49295f76fe2b67803b299c5fbe7ab12f01f4faf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5520d52bce6d837491accd768420cb44e9c64b6bcd4063817668fd5245fc9cfc"
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
