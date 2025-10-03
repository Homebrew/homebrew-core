class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.15.0/zint-2.15.0-src.tar.gz"
  sha256 "bce37d9b86e6127cac63c8b6267ac421116d4ac086519d726eb724f5462d98c7"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "78ee74be96b821a40bd3ae74e02a8648b8b44ebcf3ca77f4253318715129a6c5"
    sha256 cellar: :any,                 arm64_sequoia: "c5d7f8040c04a1c080f2e6bbfe80eb2fdf78d92871cd39c9b1e9ad3ff25ba12e"
    sha256 cellar: :any,                 arm64_sonoma:  "7d8b21def98c08bac6c057bad1f0e1e46c0f31cc50d55ea3eb6a0dc272f57693"
    sha256 cellar: :any,                 arm64_ventura: "ae1fe857c6cb02ccdc61ac948f55a0bc4e1cd40a0185b6fdb4df2eac5a79e741"
    sha256 cellar: :any,                 sonoma:        "6758e30095b4f04942810c3cbfc9d70ea8d80091d9cb7292fcbc4dfa9821ab12"
    sha256 cellar: :any,                 ventura:       "8c644792c866b56195e2d3ffcf2014c0543e6deb06018fdf17288f91d356ab75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18ac58ed7f5da5a5e3ae10b6d33a9c9e2437506d46067a9c4452dfa6c68c841e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa3c1b905b3ec72b674dbe41efe695a000f9db414d05f9bf0def635f3a9b0105"
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
