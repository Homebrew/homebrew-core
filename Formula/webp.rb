class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz"
  sha256 "64ac4614db292ae8c5aa26de0295bf1623dbb3985054cb656c55e67431def17c"
  license "BSD-3-Clause"
  head "https://chromium.googlesource.com/webm/libwebp.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "bb5fb8f745151f8a79d54b7217d9e4fcf50d035bbec852e4f4bcef3987e52bdb"
    sha256 cellar: :any,                 arm64_monterey: "9318abd9810e6f1e74739da95508fc72d752c4faf2ff8721582f27d819380c48"
    sha256 cellar: :any,                 arm64_big_sur:  "4e4fdc09b03666abe0aa11b796bb7f69745118573f649d186bb460f9dbe1028c"
    sha256 cellar: :any,                 ventura:        "de25d6fbb1d52c3f070e27c2f06c9a4a4bcedc1117081225d1741f489037d3d7"
    sha256 cellar: :any,                 monterey:       "c46189d9662044e2a7614ffc0d6a47b69708da24be499e26a65b7c83faae5b56"
    sha256 cellar: :any,                 big_sur:        "dc0ff932a09933b65121932bc6e14f4ff97e4c6a29a0148fd161ba81244a5a6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "370e9fd6f9649f93f0f29d284ae492a4770e8bd7be811ff7a596e32ce982ee4e"
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
