class Rgbds < Formula
  desc "Rednex GameBoy Development System"
  homepage "https://rgbds.gbdev.io"
  url "https://github.com/gbdev/rgbds/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7097e713384376c324bb001707b4d3924dc7051358a54069eb0bfd424ebe3c4e"
  license "MIT"
  head "https://github.com/gbdev/rgbds.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ad21b3895b6bfd25f83a1a19e106befae78d42123355f1b325893e832c62e17f"
    sha256 cellar: :any,                 arm64_sonoma:   "644ff192797102456f26f9513540de9ce86765c1177ae24fe6619a2b07c2ad32"
    sha256 cellar: :any,                 arm64_ventura:  "5f8011ddf89542afdf952b5d834fc376cf7e6690988a498426bced15ce6a9200"
    sha256 cellar: :any,                 arm64_monterey: "b263ebc8a8e41690a7e94689d6434bf647d94e362691e591ed6a7d0138990126"
    sha256 cellar: :any,                 sonoma:         "e91b064c360fa310ba66e30722e088e4cbbb49ca17600945aadae3553d879c01"
    sha256 cellar: :any,                 ventura:        "a4dd6e7e0b556d48aebb97befd45473a29828eef7fc0a82c63d4fd13cece9986"
    sha256 cellar: :any,                 monterey:       "2d1008de0fbf9ec18d5d42d08adc1451db21a3f644de7057d07d346922dbe122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a5f81b9c7ae0f312183e29b08faeb27da936ec5c443db3c404e1fcea782b316"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"

  resource "rgbobj" do
    url "https://github.com/gbdev/rgbobj/archive/refs/tags/v0.3.0.tar.gz"
    sha256 "273fe064750503e3687aeb24026074d78406724d313c48c01c3ad10920896962"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    resource("rgbobj").stage do
      system "cargo", "install", *std_cargo_args
      man1.install "rgbobj.1"
    end
    zsh_completion.install Dir["contrib/zsh_compl/_*"]
    bash_completion.install Dir["contrib/bash_compl/_*"]
  end

  test do
    # Based on https://github.com/rednex/rgbds/blob/HEAD/test/asm/assert-const.asm
    (testpath/"source.asm").write <<~EOS
      SECTION "rgbasm passing asserts", ROM0[0]
      Label:
        db 0
        assert @
    EOS
    system bin/"rgbasm", "-o", "output.o", "source.asm"
    system bin/"rgbobj", "-A", "-s", "data", "-p", "data", "output.o"
    system bin/"rgbgfx", test_fixtures("test.png"), "-o", testpath/"test.2bpp"
    assert_predicate testpath/"test.2bpp", :exist?
  end
end
