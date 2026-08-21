class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  url "https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.1.1/zxing-cpp-3.1.1.tar.gz"
  sha256 "c3c02c29c0b519de7bd4e25b376e606e87f0761befd1282815642a2246613d14"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3795a6d9898fa8ef01980dc62af5663ea9c5095bd4632030ca912740aa70ee5d"
    sha256 cellar: :any, arm64_sequoia: "292f6fc70f5ffc2d7d92c22f211d3a0d78784760b59bd430e80f60f15ee38b7d"
    sha256 cellar: :any, arm64_sonoma:  "7d236370587c353fc70e88d7967cb3529ee4d5c44d2ddb439d9609e69068ff34"
    sha256 cellar: :any, sonoma:        "56c38ea9e718f8564f98baeeb3209411c5db1100608936bac2231aa03bf0d3c5"
    sha256 cellar: :any, arm64_linux:   "528829b770cfe30f3b05704fd8f541fd36206b9dc9918451e0fe4209a1ad31fa"
    sha256 cellar: :any, x86_64_linux:  "12434a21e3211b17cf5d7825a10e05e60d6d28d198476ecaf29dcbdb036e2f36"
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
