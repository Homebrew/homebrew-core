class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.6.0.tar.gz"
  sha256 "e4ab7009bf0629fd11982d4c2aa83964cf244cffba7347ecd39019a9e38c4564"
  license "BSD-3-Clause"
  compatibility_version 1
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  livecheck do
    url "https://developers.google.com/speed/webp/docs/compiling"
    regex(/libwebp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "85d3cb86c87f53f027b48cdfe15a31e82932caa43344a6fe06e00e5de402a3e7"
    sha256 cellar: :any, arm64_tahoe:       "89d7380c156284433cf5a130b82423b1a3d83b4aac88fe88ba35d174bcc9d3b6"
    sha256 cellar: :any, arm64_sequoia:     "3f5c1ccc592312b2170bc1ea673f902aa65fc479aa9a4c308ff0b1b1a35315fe"
    sha256 cellar: :any, arm64_linux:       "3aa68517215779bc0c0a877c934c81ed82e5d5727c0114878ccfd6a1fa138fae"
    sha256 cellar: :any, x86_64_linux:      "74466119f8e80a2375631657c0daaf53c910938c4a8754385c579b4d71f95887"
  end

  depends_on "cmake" => :build
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_DISABLE_FIND_PACKAGE_TIFF=ON
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
