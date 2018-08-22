class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/6.2.0.tar.gz"
  sha256 "cdf0c2179ae7a7931dba52463741cf59024198bbf9673bf08415bcb46344110f"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "a5a063becd2eb23cb60d027dff701e383c4004ccfe64b678f2f25d99d9ddc3b2" => :mojave
    sha256 "2ab6bb019753ec963c3809c7a309752641a4610a324a232e019d38ef1a98d0cc" => :high_sierra
    sha256 "b7a71975137d0e8e5cf427ff671657c1abda3aeff595b47bb64aa134c0f1bf78" => :sierra
    sha256 "64c3d24dbee1c26d102936bd65dc4fe6235f4146b9f8cdfc303849787d95e66b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tinyxml2.h>
      int main() {
        tinyxml2::XMLDocument doc (false);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-ltinyxml2", "-o", "test"
    system "./test"
  end
end
