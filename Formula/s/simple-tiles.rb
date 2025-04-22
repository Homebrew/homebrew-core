class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 5
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36390e47953ff999ef27071f99ab4431f71de4a3734f9afe084a6612e95560e6"
    sha256 cellar: :any,                 arm64_sonoma:  "5fe279a2263e8b191c494afd60febd6debef4d8e758890b8b3e17c15040e94e4"
    sha256 cellar: :any,                 arm64_ventura: "100054d6eab29d9146d6c26682580c3d463c5ba3924f4f1d656d1e7a99594abd"
    sha256 cellar: :any,                 sonoma:        "dae7ca47c278721f39b13fa071ffed21a10bd789984bf77b389d19df84d6bf4e"
    sha256 cellar: :any,                 ventura:       "a0bff8824199fc2462c1144ea67b1efdc4cd59efccb8cb12d4aa73889b38b2cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26d40c2d590d0ad8667c4f887212fd9ed3470ec31435bf314dec5cbdcc36cda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b9bddf6bb8104fa5720df1b5a14e1f15710a09f04ccd9901555cc61bfd9d568"
  end

  depends_on "pkgconf" => [:build, :test]

  depends_on "cairo"
  depends_on "gdal"
  depends_on "glib"
  depends_on "pango"

  uses_from_macos "python" => :build

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  # Update waf for py3.13
  resource "waf" do
    url "https://raw.githubusercontent.com/propublica/simple-tiles/d4bae6b932ef84cd115cc327651b4fad49557409/waf"
    sha256 "dd9dd1895f939d288823a7e23d7914c4f9fb018828da64842953e2a857a08713"
  end

  # update tools/clang_compilation_database.py for py3.13
  patch do
    url "https://github.com/propublica/simple-tiles/commit/a6e8b5738bb7b935d0579a5b514c49720e9eeeff.patch?full_index=1"
    sha256 "b0d9226069b8c5cedd95d3150b46d123a14259a60f79d2827a5a99b9ce6e8944"
  end

  def install
    python3 = "python3"
    buildpath.install resource("waf")
    system python3, "./waf", "configure", "--prefix=#{prefix}"
    system python3, "./waf", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    C
    cflags = shell_output("pkgconf --cflags simple-tiles").chomp.split
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lsimple-tiles", "-o", "test"
    system "./test"
  end
end
