class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/8.1.0.tar.gz"
  sha256 "23c95af3b981cf9a56c7f669505832c93427cb684811bcb6c9311bd18fa9bc30"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dbe26d21724cc71aa66091a73c1d9f6a54e952f7a38877749062a8c5cd4dd4e8"
    sha256 cellar: :any, big_sur:       "dc187de7b8ecdaae5ca53fb68c940d01dd30d13d635a57dda778f5577ffaaefa"
    sha256 cellar: :any, catalina:      "de43d8d170826747b593e29cff70f84fba2e35aef5c25bec5c02c406c29bbf84"
    sha256 cellar: :any, mojave:        "65527a3b8385c01fabbaeef1ff1dc3cc301dcf5f49e0875d210d80fc5181379d"
    sha256 cellar: :any, high_sierra:   "eaacca900292a86dc5d4e95e2a71042a6e2fe7e766341d0b5078cf99cd25c0da"
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
