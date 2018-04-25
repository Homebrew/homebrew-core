class Utfcpp < Formula
  desc "UTF-8 with C++ in a portable way"
  homepage "https://utfcpp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
  sha256 "3373cebb25d88c662a2b960c4d585daf9ae7b396031ecd786e7bb31b15d010ef"

  def install
    include.install Dir["source/*"]
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <utf8.h>
      #include <cassert>
      int main() {
        char utf_invalid[] = "\\xe6\\x97\\xa5\\xd1\\x88\\xfa";
        char* invalid = utf8::find_invalid(utf_invalid, utf_invalid + 6);
        assert (invalid == utf_invalid + 5);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                  "-I#{include}/utf8",
                  "-L#{lib}"
    system "./test"
  end
end
