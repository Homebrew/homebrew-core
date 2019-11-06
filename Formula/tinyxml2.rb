class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/7.1.0.tar.gz"
  sha256 "68ebd396a4220d5a9b5a621c6e9c66349c5cfdf5efaea3f16e3bb92e45f4e2a3"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "2326b039acf4a2550a21fab854fc9a03c0583cac2837feab19f3caf03975f09d" => :catalina
    sha256 "93e79de7e9acda8014942e9fb1fccc8be218af0799e0465752e967adc05d74bb" => :mojave
    sha256 "b33ac4fad0b064be28130659f32ba3f44cbd16a8a5610d5fdb33026ce7eb5bf5" => :high_sierra
    sha256 "3519517f7b877558d0e8ff5784970fe30c6c4d2e06b437ef3e1c972f2890056c" => :sierra
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
