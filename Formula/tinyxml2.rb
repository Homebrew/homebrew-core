class Tinyxml2 < Formula
  desc "Improved tinyxml (in memory efficiency and size)"
  homepage "http://grinninglizard.com/tinyxml2"
  url "https://github.com/leethomason/tinyxml2/archive/9.0.0.tar.gz"
  sha256 "cc2f1417c308b1f6acc54f88eb70771a0bf65f76282ce5c40e54cfe52952702c"
  license "Zlib"
  head "https://github.com/leethomason/tinyxml2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "effd8b312b04bfdfd2eb016bac6b84107a3e97c0a7edd5ccbe61ef6df23ff81e"
    sha256 cellar: :any,                 arm64_monterey: "f9a491c1cd89ac354cd60cb58ec8b919894d3178d43554a1bf5ecb037bb0f3e5"
    sha256 cellar: :any,                 arm64_big_sur:  "a5c5e7ea6dcc446b1f7d38441ac4a226afa14b3e5e5eb890d3105edf54f91db6"
    sha256 cellar: :any,                 ventura:        "fec107e0db5c5926746bf43723fd99a616307ba8dfeb70d99ab9e2c4050cc186"
    sha256 cellar: :any,                 monterey:       "24e501c8045b7546c9b030d1f9fbc53f06988112decc418f61ff1c460e2cedec"
    sha256 cellar: :any,                 big_sur:        "4df58f65bc6629e1884225503622e07f26e52a9690e24a6e959dd1304b11dbb8"
    sha256 cellar: :any,                 catalina:       "d09e9f6a1833923fea9528a056c663cb5e05b71afacc1fcec7b9b6fbeb30772f"
    sha256 cellar: :any,                 mojave:         "84db2d094fa220b2269cd97bed3fb50edfd23061f6ab9dece09a82562e73a975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff49aa9a2ab33353cab7cf34aee1013b3ba5a925b49dbccf9f7eee915affe02f"
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
