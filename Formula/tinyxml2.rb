class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/4.0.1.tar.gz"
  sha256 "14b38ef25cc136d71339ceeafb4856bb638d486614103453eccd323849267f20"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "3573f6ed8a061a216c21d4b79927d398557c3a58184932d155ca9fb3faa5cc4e" => :sierra
    sha256 "6e7c475763e105d85871e2e435c6513ba80f92cd133c5e94e6d794c20e104fbf" => :el_capitan
    sha256 "09ba4ebd7912673e17dfd9a3067e7f9795d4906df88d8c440e26a5550cd90bfa" => :yosemite
    sha256 "1ee467e92b699a09c7621cf35b4545d7860b1932b37f9dfe93baeb59363a3a92" => :mavericks
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
