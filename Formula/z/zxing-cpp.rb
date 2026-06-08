class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  stable do
    url "https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.0.2/zxing-cpp-3.0.2.tar.gz"
    sha256 "e957f13e2ad4e31badb3d9af3f6ba8999a3ca3c9cc4d6bafc98032f9cce1a090"

    # add support for homebrew specific STB_IMAGE_INCLUDE_DIR config option
    patch do
      url "https://github.com/zxing-cpp/zxing-cpp/commit/764f7ac3438f0e7638da27ad00cc2147312a2ea6.patch?full_index=1"
      sha256 "2174f23e784b8fd68a5f0b3fdf467f9c22c448b73ca40133be711486dfe8d82b"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1957bd2c1cd602a47a0e9458252fb997013ed247a40122dd3bb6f88574cf3977"
    sha256 cellar: :any,                 arm64_sequoia: "35ef6d8c193f3171538954dca59112faa8afb153a0799a5f8fad14d608491395"
    sha256 cellar: :any,                 arm64_sonoma:  "3edeab4554d87d39a1e6f786ca85477ebad597ef9c5e4222be692d171f0d148b"
    sha256 cellar: :any,                 sonoma:        "53c94ba2fdd891d609cee8390895289e1977a524edcea5f02cffde347f85b8e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ee67c2111a969786630560ea7f1f19766c487c2ac80a6000edd14a3c9b09eb37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "956f8e6d040fb047032c2ed39956947b40ceeaecd7f6f21b561c14677cbd64fa"
  end

  depends_on "cmake" => :build

  resource "stb_image" do
    url "https://raw.githubusercontent.com/nothings/stb/013ac3beddff3dbffafd5177e7972067cd2b5083/stb_image.h"
    version "2.30"
    sha256 "594c2fe35d49488b4382dbfaec8f98366defca819d916ac95becf3e75f4200b3"
  end

  resource "stb_image_write" do
    url "https://raw.githubusercontent.com/nothings/stb/1ee679ca2ef753a528db5ba6801e1067b40481b8/stb_image_write.h"
    version "1.16"
    sha256 "cbd5f0ad7a9cf4468affb36354a1d2338034f2c12473cf1a8e32053cb6914a05"
  end

  def install
    resources.each do |r|
      r.stage do
        (include/"stb").install "#{r.name}.h"
      end
    end

    args = %W[
      -DZXING_DEPENDENCIES=LOCAL
      -DSTB_IMAGE_INCLUDE_DIR=#{include}/stb
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <ZXing/ZXingCpp.h>
      int main() {
        ZXing::ReaderOptions options;
        (void)options;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lZXing", "-o", "test"
    system "./test"

    assert_match version.to_s, shell_output("#{bin}/ZXingReader --version")
  end
end
