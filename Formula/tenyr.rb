class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.4.tar.gz"
  sha256 "15785cf62bbf59bed88cfe1c3f41de63b3fe421695ddd5481ceb9a7a5eea27ff"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "75386fda5b5c122eee81f9c1a59a4861e68faa5e64732366af42ecd9eb928c0c" => :sierra
    sha256 "388ee807fdfe7c4bd31676d7a6ad347ee5d35dcc6e48cddc394a2eb739cda80f" => :el_capitan
    sha256 "8273f303c3be52b31f29e047a8bc4f6171f9814a27f7cd14530d944a3e94c932" => :yosemite
  end

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
