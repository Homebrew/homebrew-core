class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/7.0.1.tar.gz"
  sha256 "a381729e32b6c2916a23544c04f342682d38b3f6e6c0cad3c25e900c3a7ef1a6"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "233eac209902fba3aebf51fa81d15a5b472064eec22bc5364b8685453166a08a" => :mojave
    sha256 "cc447f7fcf805805c97e4d9aedacd5638b103177de32fb30986bcaec37698c18" => :high_sierra
    sha256 "90fda15a1ce430ed1e77891a23c65a53092deca1b585330aa86fbde8ea3b80b5" => :sierra
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
