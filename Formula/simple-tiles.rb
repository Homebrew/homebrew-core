class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 12
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "8d09ede3891adf6d32df74873d5365d864858a1ad1eb80a905186efd8f35996b"
    sha256 cellar: :any, arm64_big_sur:  "48cde5e0f3f7db77717a96c6f72878b65f49dee17d21cc9a0dda8758879d9e6c"
    sha256 cellar: :any, monterey:       "beb9fc72f05678da06c5eada56a6e2b113e288a9692817258a334d7f1adc1712"
    sha256 cellar: :any, big_sur:        "745550aa590b1eaf83c24f02812fcf5f6f6989057c81cee02ad31e680dabb42b"
    sha256 cellar: :any, catalina:       "fe567eb488eaa8d8f39b5e76804bdf4ddbc96c6ca11bf77dadcc340869a83abf"
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
