class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 2
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a47cd53e74ec486fc2159b4ee55fddb202351c8dec99ef59819728156fc248ef"
    sha256 cellar: :any,                 arm64_ventura:  "cc9b25089707786c77c954f339412e843776ebc992ed36372b838882336be711"
    sha256 cellar: :any,                 arm64_monterey: "e2b588d5065161fd7db30ddcbb167fd02bbe15a42e36a624d2d2ab57fa5a719c"
    sha256 cellar: :any,                 arm64_big_sur:  "a269fabb33d530d300f405e4363d195af41a83ff2801a08d38cf3b1cb6e365bc"
    sha256 cellar: :any,                 sonoma:         "37fd7cef4daca2b641a7960e7f4271f9329065af95edc794219b70ac024b7b79"
    sha256 cellar: :any,                 ventura:        "a39df0a3650cf0b17f8292bbae7b27771f8016a0651ffc3359c6d87a9b2056a9"
    sha256 cellar: :any,                 monterey:       "edbff9be05fb653675118d54d517094a508fc34c2e35d0306bd6261858cc53d0"
    sha256 cellar: :any,                 big_sur:        "8cfe1ac09b2c94e3ecc194f606bda135202afc7b8877954ca835a15b712a6d59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17e7ce8eb9cf3eaff8118ee13604924e1cf320ab1176b175b746f2d2d26198d5"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  uses_from_macos "python" => :build

  def install
    system "python3", "./waf", "configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    EOS
    cflags = shell_output("pkg-config --cflags simple-tiles").chomp.split
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lsimple-tiles", "-o", "test"
    system "./test"
  end
end
