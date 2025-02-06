class Zint < Formula
  desc "Barcode encoding library supporting over 50 symbologies"
  homepage "https://www.zint.org.uk/"
  url "https://downloads.sourceforge.net/project/zint/zint/2.14.0/zint-2.14.0-src.tar.gz"
  sha256 "5ceb8a169a315402a99a2493ea42f7b832cf7aea0051da9beaddfbf7e2e64a07"
  license "GPL-3.0-or-later"
  head "https://git.code.sf.net/p/zint/code.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/zint[._-]v?(\d+(?:\.\d+)+)(?:-src)?\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "462d72fd02fe5277525558b943d6032b77ced0ea4080128eb6ea10af81fabe5d"
    sha256 cellar: :any,                 arm64_sonoma:  "071c41160def6543a47544d88d7bc461845e29943ebf539e1e1f257f49f3c937"
    sha256 cellar: :any,                 arm64_ventura: "43f90242fedfe89427d93afe142796966c5cd642ce42393603ed2506a5f648c4"
    sha256 cellar: :any,                 sonoma:        "a15ef5ea60821b67cd995dbc271cb305edcdcd64c207e907047f8c92e21745cf"
    sha256 cellar: :any,                 ventura:       "e1a6c6f8f964ecd0111d5140c55c3864bc2839b21c370ddfcbe5d0ae75d83658"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "547aff314d6e71ec65afd097c0c11f5d836a92d03779a739378b3b8890b9ab7c"
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
