class Yazpp < Formula
  desc "C++ API for the Yaz toolkit"
  homepage "https://www.indexdata.com/yazpp"
  url "http://ftp.indexdata.dk/pub/yazpp/yazpp-1.7.1.tar.gz"
  sha256 "8cf8b9a84cee6748013beaf8f79a432e4c65b9f04f4c80452bc2f3e93354294a"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "0874f5f7c57a5c611d574abe983ef9dee2796b115deb8290de008c1e9964cc45" => :big_sur
    sha256 "868f7e41ffbd9bcd8c2c59db254182fe5f2fa934ec25c1928fbd0032ee480dd3" => :arm64_big_sur
    sha256 "5136d27fa1e25ceccbd1a73dc1655fa039c99f3d99faaae07239865ea22ee777" => :catalina
    sha256 "60a07217d07224b442d2810d99261b48f846df54dd06eb5e4a4688f0864d1939" => :mojave
    sha256 "0d783b21b0cd116bef6b358866b2ac557e340c4e5dd6961c6bd843b6bcda68b7" => :high_sierra
  end

  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <yazpp/zoom.h>

      using namespace ZOOM;

      int main(int argc, char **argv){
        try
        {
          connection conn("wrong-example.xyz", 210);
        }
        catch (exception &e)
        {
          std::cout << "Exception caught";
        }
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}/src", "-L#{lib}",
           "-lzoompp", "test.cpp", "-o", "test"
    output = shell_output("./test")
    assert_match "Exception caught", output
  end
end
