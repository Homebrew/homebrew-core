class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 8
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "edf9216d53cb586423cea902e868c01eed41bfc9af3950ca633d96b39bb080a1"
    sha256 cellar: :any,                 arm64_sequoia: "9e7509c6008ad30c1ada39a3f2cae499811cb550812d139fce8e05113c694234"
    sha256 cellar: :any,                 arm64_sonoma:  "9e671db842033323cdc4760112fb6a9f70d0aa7256087c1b6a2eb5489c43544b"
    sha256 cellar: :any,                 sonoma:        "a348fe567a5c1f94f8f9558789c7b94e98f9df8af3d4e4614588ce502e2867c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d506fade6312fae86ee06ba9689f395cd7d0fd9b701e517b6a688eb2c5f41d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d39541f12962113b3c9f93d8d3c652adf3aa2f68550a2f9e0a0a4645cd5b765c"
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
