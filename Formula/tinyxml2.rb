class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/6.0.0.tar.gz"
  sha256 "9444ba6322267110b4aca61cbe37d5dcab040344b5c97d0b36c119aa61319b0f"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "53192ab7ffcdcbb79b4d2ce4278ebf062395392b0397a857fe5ba212e41a7317" => :high_sierra
    sha256 "b570b43054e9a1e7a0bf9ada534d8d823b04fb944011a94e31d1e984fe615999" => :sierra
    sha256 "36a3d12afbb44d6b9c9d5c2fb36499e9a5d56b46c7c72141d78e2aa9041d282a" => :el_capitan
    sha256 "fe1653e341e976a0d226cab0842035703b369caa7504b069ffe26b7717f85d98" => :yosemite
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
