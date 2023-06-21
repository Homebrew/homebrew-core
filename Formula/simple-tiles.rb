class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/e-n-f/simple-tiles/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "3ca93241a8ce0f5f2933335be215ddd687c966c138893c5f9f5c4ca77b52de11"
  license "MIT"
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5252e9ff36191861cf16c4b9812ebe7a102bbeebcb78885f8572f086e0aae563"
    sha256 cellar: :any,                 arm64_monterey: "2b0e038282710117a9307cf7fee0ef4491a1c612331c2002b7a8cf8f3cdb540e"
    sha256 cellar: :any,                 arm64_big_sur:  "827a05070f0eb7d02850aa47f58bb9fd98c801e46c998133e4202757b8e6dcb8"
    sha256 cellar: :any,                 ventura:        "31162ff0e202da05f18fda98100983322b17e23d4b151b827f4e5a028148fae8"
    sha256 cellar: :any,                 monterey:       "af5d85a6e8eca24129ae215ab6ffa2c3079172ae2c4dbfb1187ee4e73344745b"
    sha256 cellar: :any,                 big_sur:        "f7393f4a5ec721669ae1125fddd5381b2e9b7da6915c7d7aa477e7aea5a1809f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e064d743920e4e704fbaef907e24c2a43dcf52b82da8ea6d65392696f76349"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

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
