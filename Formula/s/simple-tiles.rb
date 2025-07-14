class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 6
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d3aaa726bd349cc30a81762fd0a1b0601e4d9cf866023c29ff63a6e60226620c"
    sha256 cellar: :any,                 arm64_sonoma:  "abe65b73e6079f2b796164a3290cff1570ce7a2eeb1c310ebab9ec2160ac97c6"
    sha256 cellar: :any,                 arm64_ventura: "f49d942f1152dbe63628654fb6063e621b17397ec41c46b1741acd2caaacfd3c"
    sha256 cellar: :any,                 sonoma:        "3b4ace3dfc2511c747a5dfe7a5ae9b214694d2908b3443c07284883b046df9e2"
    sha256 cellar: :any,                 ventura:       "bec15845f74bb0ea00e16a708fc4eca25e133357693dd80b3f460b189d93fa0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b811346839863479eee8eb09a6537da5b7dfcc211cd2e532ffe82989e5111df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "403a1c58f940fa9bb9bf5d4acccf8b64c88b105c37295220bcd07bc89f3d5282"
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
