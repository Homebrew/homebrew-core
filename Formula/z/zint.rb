class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.13.0/zint-2.13.0-src.tar.gz"
  sha256 "0e957cf17c3eeb4ad619b2890d666d12a5c7adc7e7c39c207739b0f4f5c65fa2"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a5ef81a0327576c485d43464a9c83f58e900424df09618110063e36b482672d5"
    sha256 cellar: :any,                 arm64_sonoma:   "6fa2b89bbdb82d0a6beb39c37a3e449c16ef001d061afa494c88a214fd8202b9"
    sha256 cellar: :any,                 arm64_ventura:  "84bd1d082df48a9534db60ec62c89125078019740ca2c5e19f099e8d69b86e81"
    sha256 cellar: :any,                 arm64_monterey: "3007752c499d7ec86f7ead26a836e244416e47fecdfa89e77b03e88259a1f550"
    sha256 cellar: :any,                 sonoma:         "0fb9b4f458c89f1f724f5db0878054a7f437251cd206ba9dbbf0524e2e20d354"
    sha256 cellar: :any,                 ventura:        "2e8d222257114885ee73d6f52a47631e6127c377c673fdfa68e7c38502d55a45"
    sha256 cellar: :any,                 monterey:       "6b897319d57452f86775c339d286d1f0be09734eaf548e1b92964a1b2e2465c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327b6d35b49ace62afa69f3e57d79d14ffb288d8a59bd79a678395ff83c68fec"
  end

  depends_on "cmake" => :build
  depends_on "libpng"

  def install
    # Sandbox fix: install FindZint.cmake in zint's prefix, not cmake's.
    inreplace "CMakeLists.txt", "${CMAKE_ROOT}", "#{share}/cmake"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lzint"
    system "./test"
    assert_predicate testpath/"out.png", :exist?, "Failed to create barcode PNG"

    system bin/"zint", "-o", "test-zing.png", "-d", "This Text"
    assert_predicate testpath/"test-zing.png", :exist?, "Failed to create barcode PNG"

    assert_match version.to_s, shell_output("#{bin}/zint --version")
  end
end
