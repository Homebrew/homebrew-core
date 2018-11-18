class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/7.0.1.tar.gz"
  sha256 "a381729e32b6c2916a23544c04f342682d38b3f6e6c0cad3c25e900c3a7ef1a6"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    cellar :any
    sha256 "31be8d20de0c0fd6f6806633f925b03571e9ce84cacd864c7d97b6369e170960" => :mojave
    sha256 "a48f8e237ad1c5792f1fff69c14c8c0958a949a0f87da90d914da39a01a3482a" => :high_sierra
    sha256 "a6335f77b1a0a8fc1f98a028e446c09848f7df45816f6ead363e9c7cc4c85e92" => :sierra
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
