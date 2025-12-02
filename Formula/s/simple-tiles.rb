class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 7
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c6422d3ddffa35605443bdf18158914654450f0ad0362673c6b136e1a116af4d"
    sha256 cellar: :any,                 arm64_sequoia: "7751a5ff3fe02cb473d4accf7cd2e4f31813b6a35521b9357b0502c202c6a820"
    sha256 cellar: :any,                 arm64_sonoma:  "daa34638b944a33d7abefd9d2e12787baf1a055ef331b08d9d29db038e840574"
    sha256 cellar: :any,                 sonoma:        "a43ad30dc8509a71c44e09a8ed58416cd5f1c6b1f29e661223187564438eccd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1149b833c6586359e97f93673888bf3dbd68f070d74a819cd028c44ad054d1fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cac3424f59872d80f8dcaadc2ab0522f3cfafd7c12a6698c573d71767b66077"
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
