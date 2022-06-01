class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 16
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d93f8451c371817a71ef2c71e3d68dda6713000c3244534bbabfcf5938951a72"
    sha256 cellar: :any,                 arm64_big_sur:  "bcc423c6553f1bc0de60242606b9436615f548d4cb4fe265e97dc8ee4e34d25f"
    sha256 cellar: :any,                 monterey:       "a847d335313162fc6db89406e7649ba9a576c3724956d14a85ad1948cbfd9b95"
    sha256 cellar: :any,                 big_sur:        "de4621914e4836fb4592f76efd8ecc6f0f312267b7f403f39872af99301a67f0"
    sha256 cellar: :any,                 catalina:       "c3b64b07f30976f6c4485c64f35d32a4598c0726f3002660a26a8fa2563b9816"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c98cfcaa200c76a1251fa6ded31558c92da6a5b416d209e227ebba1e74e250da"
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
