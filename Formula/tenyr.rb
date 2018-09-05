class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.6.tar.gz"
  sha256 "04b92514927abfb5b7814a203bd296e8b528ae759c755402427db4cbc3ddbc47"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "79f1f08181a4a3563a95e002068cde55db5dd83f1e67e4baa10937659d72bb97" => :mojave
    sha256 "7ed5a7f7573c9970216c21dc1586fef1107ea97e20f143dd11ee41c6627d13b3" => :high_sierra
    sha256 "0b734e40019ad537072b648526d08c6d34c669251ca5bb8b4c22a3c2bd3ea745" => :sierra
    sha256 "1b09019bb0131b4ce6599612e55a828d22390757473c22dceab47aa30671fd1f" => :el_capitan
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
    # Right now there is no way for `build.with? "jit"` to be true
    args << "JIT=0" if build.without? "jit"

    # Use our own build directory (tenyr's default build directory encodes
    # builder platform information in the path)
    builddir = "build/homebrew"
    args << "BUILDDIR=" + builddir

    args << "SDL=0" if build.without?("sdl2_image")

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

    assert_match "C 0000001b", shell_output("#{bin}/tsim -vvvv test.texe 2>&1")
  end
end
