class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.16.0/zint-2.16.0-src.tar.gz"
  sha256 "37e767afada2403bb9ae49b93a19eb0a9e944a0c278d9f23522746b3d08a3c4b"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7e1e9e0579a80d03f3b61b0ce43125bc5cc2f3e52eee5840f66fc89b039edfc9"
    sha256 cellar: :any,                 arm64_sequoia: "e40a7f6e07fd6c4d873d532b61f7c145399ed478dce78249e0f374b67fae9b6b"
    sha256 cellar: :any,                 arm64_sonoma:  "84d4f6841542575a6e6d0da64a7094ade3b5261d828b28dd4fc0d9d5e7b0883b"
    sha256 cellar: :any,                 sonoma:        "46450e362375e3f33ba2c737eafc265ad23bfd1fa49023e71ccc6622b58e1362"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb80afc876cc8f6106f743fb58fa182dd679729a7a3ef4744b6ee7460efac62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e2e7d47df4be55601f299c6ac215f96b262779bfeec32b53402a6bc8300664b"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <zint.h>
      #include <stdio.h>
      #include <stdlib.h>

      int main() {
        struct zint_symbol *my_symbol;

        my_symbol = ZBarcode_Create();
        my_symbol->symbology = BARCODE_CODE128;
        ZBarcode_Encode(my_symbol, (unsigned char *)"Test123", 7);
        ZBarcode_Print(my_symbol, 0);

        printf("Barcode successfully saved to out.png\\n");
        ZBarcode_Delete(my_symbol);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lzint"
    system "./test"
    assert_path_exists testpath/"out.png", "Failed to create barcode PNG"

    system bin/"zint", "-o", "test-zing.png", "-d", "This Text"
    assert_path_exists testpath/"test-zing.png", "Failed to create barcode PNG"

    assert_match version.to_s, shell_output("#{bin}/zint --version")
  end
end
