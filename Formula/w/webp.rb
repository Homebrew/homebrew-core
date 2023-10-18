class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.2.tar.gz"
  sha256 "2a499607df669e40258e53d0ade8035ba4ec0175244869d1025d460562aa09b4"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47ca7e11b4c06d638c857a72c9383b7d528a013b7aaafbde33d4cf59f91359ed"
    sha256 cellar: :any,                 arm64_ventura:  "e36770b86bd3d3a71469dc66bd2fe5070f80d8d1f4dab1c6ff2d9732bd9e0ed3"
    sha256 cellar: :any,                 arm64_monterey: "1d7039a4068e31d4643eba3e516b72df0bfede9c800dda4ff4c08de927f1947a"
    sha256 cellar: :any,                 arm64_big_sur:  "419842fa92f7b818f452628a80ef4391f8d1b947b602f0cf84f486a458c4a721"
    sha256 cellar: :any,                 sonoma:         "1acdc37723e07cf0acc3eade96fa8cc1e5e7c6e6176c84b61a0813cb07a61368"
    sha256 cellar: :any,                 ventura:        "9296ad4f9d17026fa88995b9fb79c942179e6bad159b1d4a36827e8d9bc57c19"
    sha256 cellar: :any,                 monterey:       "4de31743324ead0cd7978083192bb107f6cd09b11d4a81be4b6c550b91a2136c"
    sha256 cellar: :any,                 big_sur:        "28cbb05c0cc1d30882e1511b6790300f3bcc82a0bc38031e55f0222c875a877f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f701c0f638b6392585ab57acb0b16b64e4df0fffc1665e12c0d9f5c0547871df"
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
