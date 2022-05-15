class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 15
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e79b9c7a38d6a472dc4260835e7bf47c439ba6785839354d8171f7fa9a6fa494"
    sha256 cellar: :any,                 arm64_big_sur:  "b015d743907549f5f3278b4e1dea46d948dbf29e872af562bc40d0a2f3c57e8e"
    sha256 cellar: :any,                 monterey:       "2ee07009e5479600459f4eba993de5a1d708b79236f4e1ce4ca861c20e7d14f1"
    sha256 cellar: :any,                 big_sur:        "6ff45cd23c8c4b6aac0216c27d2888e07bf8fb302b161c5d84f12d8e2f0b3ee0"
    sha256 cellar: :any,                 catalina:       "66607ac5a7cf294a2caf13e099eca527f7b97d4fc94b1bdd09d8c8a607ae58e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fac8b578be9d4220ff8048f3b9f926c39ba5fdfe57cc3f1307d2d13e09e4aebb"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
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
