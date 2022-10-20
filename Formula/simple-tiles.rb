class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.1.tar.gz"
  sha256 "2391b2f727855de28adfea9fc95d8c7cbaca63c5b86c7286990d8cbbcd640d6f"
  license "MIT"
  revision 16
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1feae5d81d6053c7250b215f0479498e9b1c877a5fe9c4250912a4d68a4e24f"
    sha256 cellar: :any,                 arm64_big_sur:  "6a6fb456fa5ddbb46efd66c33f6146a8a690be8339d075900a71cb2822f8ca4f"
    sha256 cellar: :any,                 monterey:       "34c7b1151f1d76c0960fd51fe58be239c1f5500ce899a751f80f35324285f7c0"
    sha256 cellar: :any,                 big_sur:        "c0a0749749fcaff01e88bf679bad4fc6b592ddb6b01565b5e1a213a81ed840ab"
    sha256 cellar: :any,                 catalina:       "74bf35c12b55c9906e7ff0e07cd4f9b379f936735efe376267c41c57e49e276d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cecab0695264296890e13713b6ab3b890a93df255cfcf488a4e705a8d45e895b"
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
