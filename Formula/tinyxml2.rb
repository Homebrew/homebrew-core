class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/5.0.1.tar.gz"
  sha256 "cd33f70a856b681506e3650f9f5f5e5e6c7232da7fa3cfc4e8f56fe7b77dd735"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
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
    (testpath/"test.cpp").write <<-EOS.undent
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
