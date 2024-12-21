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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "e10ece3ad9a497f43c19b9b266153ab695618efa56d4fb71a3d93a30e8794d34"
    sha256 cellar: :any,                 arm64_sonoma:  "25da1a969839c498daa50512a463a472671cf26abe1620d659b7bb5a8cbc8f61"
    sha256 cellar: :any,                 arm64_ventura: "5fbe5e4ca1a6460ae98a69d41da4cfd3a7af126a11187ccc13c7d55c5efe7e08"
    sha256 cellar: :any,                 sonoma:        "d4a2bb7f9093c305ef3275bc9a9b23475ff0fb5ddf708e93b8b9ba8b3a760303"
    sha256 cellar: :any,                 ventura:       "30b378eea3097c2227e91b07571bf8577e4702c02bd53ceb9564e352574f1071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be18bbf7a53ce2f1a4d4f7f92fae9baadf888c0ea0b0bd2842050bf77bf86936"
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
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
