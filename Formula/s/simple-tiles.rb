class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 3
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da79421e0b2c78a449808e4b4cae188720efefc069176d6e1cc054f3a6079712"
    sha256 cellar: :any,                 arm64_ventura:  "d3ae8e8d59119abbcd0e98c6d14d43abd699e50e656c9a8694d0660ecaec6ea7"
    sha256 cellar: :any,                 arm64_monterey: "c7ae5f7b7fa30216177615fe35f2533064f51c5ee3423c96802cffd59fb54f8d"
    sha256 cellar: :any,                 sonoma:         "98e66e8c483db6a58ef3f2718a607164d5a662a0926341632c9739beba938d2e"
    sha256 cellar: :any,                 ventura:        "49c6d41e5a9ace104f66fad122ae9819e2cff32e0ace8b01303018c877e52d10"
    sha256 cellar: :any,                 monterey:       "53d7f80d2c1b671848fb9614f6d74e8de773b7a63edf803f50814f46c9a86f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab74bfc6d8af77e8b48a70ef4b230d02c99eb23c41783c7bc05bd20f7d7a644"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"
  uses_from_macos "python" => :build

  # Update waf for python 3.12
  # Use resource instead of patch since applying corrupts waf
  # https://github.com/propublica/simple-tiles/pull/23
  resource "waf" do
    url "https://raw.githubusercontent.com/propublica/simple-tiles/e402d6463f6afefd96a2e2d5ce630d909ba96af1/waf"
    sha256 "dcec3e179f9c33a66544f1b3d7d91f20f6373530510fa6a858cddb6bfdcde14b"
  end

  def install
    python3 = "python3"
    buildpath.install resource("waf")
    system python3, "./waf", "configure", "--prefix=#{prefix}"
    system python3, "./waf", "install"
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
    cflags = shell_output("pkg-config --cflags simple-tiles").chomp.split
    system ENV.cc, "test.c", *cflags, "-L#{lib}", "-lsimple-tiles", "-o", "test"
    system "./test"
  end
end
