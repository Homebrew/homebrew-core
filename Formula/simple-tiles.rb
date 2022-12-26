class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 17
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "91c2527500613ce739bf70d93ab8cb2473e843ac44eb38cb89e48b735577923f"
    sha256 cellar: :any,                 arm64_monterey: "91c1f4b7b7e0f186c981539ece21d10279e3d1228134ed80df33186e55ed820d"
    sha256 cellar: :any,                 arm64_big_sur:  "7cb19716ecc2babf25aea141f389b7f7761c81f99132fc6936727a779a35de4d"
    sha256 cellar: :any,                 ventura:        "9ff8e18e0130a53d4b3b53f6b15b5fd15cac1ae6adb2d403b7e6665f0617cc3f"
    sha256 cellar: :any,                 monterey:       "590dd2df54fd4f83c5efc83152e79485344c04cbb000a0bc2efc0cdc29034236"
    sha256 cellar: :any,                 big_sur:        "26e389105db7f26e74a394892d23e017dfd6db0e50231a1db251936020d2ea95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85f1ada4cb8e81a98e2bd582bcdc0962d992d83e91ff901b72fb488b30f44d4d"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  # Apply upstream commits for waf to work with Python 3.
  patch do
    url "https://github.com/propublica/simple-tiles/commit/556b25682afab595ad467761530a34a26bee225b.patch?full_index=1"
    sha256 "410c9b82e54365ded6f06b5f72b0eb8b25ec0eb1e015f39b1b54ebfa6114aab2"
  end

  patch do
    url "https://github.com/propublica/simple-tiles/commit/2dba11101d5de7be239e07b1f31c08e18cc055a7.patch?full_index=1"
    sha256 "138365fa0c5efd3b8e92fa86bc1ce08c3802e59947dff82f003dfe8a82e5eda6"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    system "./configure", "--prefix=#{prefix}"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimple-tiles",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdal"].opt_include}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-o", "test"
    system testpath/"test"
  end
end
