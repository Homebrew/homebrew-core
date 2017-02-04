class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.3.tar.gz"
  sha256 "62405d084d205c148f6cc4121b7fca817c3fbad5c300e3e137f4a3cb731329bc"

  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ffa29217b05ea8f74719b43369b483f0ad20ba1534b80b430e22f585b1dbc44" => :sierra
    sha256 "21f73763ac69ceca9e98ac6c8bc471772b6337ecc18acf13faabdaaabd01e25a" => :el_capitan
    sha256 "180229f9b3855dcb64225c1e5b1ea22105f3931146d2b818d61a5f9058f5fbb7" => :yosemite
    sha256 "c20b4f63feb6150edc2e46222eed8329d0e8e5bb8bdfa3f84a87059ed03d95a4" => :mavericks
  end

  # pkg-config is used after v0.9.3 for sdl2, instead of sdl2-config
  # prepare for post-v0.9.3 versions (including HEAD) by depending on it now
  depends_on "pkg-config" => :build
  depends_on "bison" => :build # tenyr requires bison >= 2.5
  # sdl2_image implies sdl2. If we specify sdl2 separately, we create
  # nonsensical possibilities like `--with-sdl2_image --without-sdl2`
  # tenyr requires sdl2_image --with-png
  depends_on "sdl2_image" => :recommended

  def install
    bison = Formula["bison"].bin/"bison"

    args = []

    # specify our own bison, since we need bison >= 2.5
    args << "BISON=" + bison

    # JIT build is not available until we can pull in AsmJit somehow
    # HEAD version can build with JIT enabled, using git submodule
    # Right now there is no way for `build.with?("jit")` to be true
    if build.without?("jit")
      args << "JIT=0"
    end

    # Use our own build directory (tenyr's default build directory encodes
    # builder platform information in the path)
    builddir = "build/homebrew"
    args << "BUILDDIR=" + builddir

    if build.without?("sdl2_image")
      args << "SDL=0"
    end

    system "make", *args

    pkgshare.install "rsrc", "plugins"
    cd builddir do
      bin.install "tsim", "tas", "tld"
      lib.install Dir["*.dylib"]
    end
  end

  test do
    # sanity test assembler, linker and simulator
    (testpath/"part1").write "B <- 9\n"
    (testpath/"part2").write "C <- B * 3\n"

    system "#{bin}/tas", "--output=a.to", "part1"
    system "#{bin}/tas", "--output=b.to", "part2"
    system "#{bin}/tld", "--output=test.texe", "a.to", "b.to"

    assert_match "C 0000001b", `tsim -vvvv test.texe`
  end
end
