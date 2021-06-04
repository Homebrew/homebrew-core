class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/8.1.0.tar.gz"
  sha256 "23c95af3b981cf9a56c7f669505832c93427cb684811bcb6c9311bd18fa9bc30"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9155cc428f70afb7d2a321af7abf6cc359ce5093eef63cbcaef70672b6644ae7"
    sha256 cellar: :any, big_sur:       "da38adaa7c2a3e6386aea80bec19886d02da078fa3c0f7ffe57d1bad2a779727"
    sha256 cellar: :any, catalina:      "73a91f44b713518ae8080170a2880f095da2e668bd90a89a1ae9c44895ce2a46"
    sha256 cellar: :any, mojave:        "f6c19f6a994e401fc15d467f2f3c56366a9b0671cd73fc0ecbe872e1c26ce011"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-Dtinyxml2_SHARED_LIBS=ON"
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
