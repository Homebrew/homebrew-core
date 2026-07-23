class ZxingCpp < Formula
  desc "Multi-format barcode image processing library written in C++"
  homepage "https://github.com/zxing-cpp/zxing-cpp"
  url "https://github.com/zxing-cpp/zxing-cpp/releases/download/v3.1.0/zxing-cpp-3.1.0.tar.gz"
  sha256 "a3eb825154f05242283e7d94d8ebdcf95beb3a534eba393cce504e91c9b215bd"
  license "Apache-2.0"
  head "https://github.com/zxing-cpp/zxing-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c73cd83b33a2f521122314cef88aa58c0d58b33def6650d9399339a3bdaf414"
    sha256 cellar: :any, arm64_sequoia: "ce69f2b8bb50aafb0c3da33f17e4e790ad09d457eca7541097ef45f122d0f65f"
    sha256 cellar: :any, arm64_sonoma:  "0eb3b0526e0185fbfc7fe5b1f003f1a936db698c22640ceab1e1951a9a2d97ed"
    sha256 cellar: :any, sonoma:        "f822918723b0ee0105bd149c91c465e07f7525bf92f49268f06e7e5de5b6a58d"
    sha256 cellar: :any, arm64_linux:   "5b1fdeafd51ed08c1834f9e0c1a58c58b66c355a95de6f802cd04c69ebb87139"
    sha256 cellar: :any, x86_64_linux:  "521923683cc1db51a61425b824503eaca4666f05bb45fc6d851bae006ad98753"
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
