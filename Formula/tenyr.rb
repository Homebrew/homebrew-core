class Tenyr < Formula
  desc "32-bit computing environment (including simulated CPU)"
  homepage "http://tenyr.info/"
  url "https://github.com/kulp/tenyr/archive/v0.9.5.tar.gz"
  sha256 "3fe066d0dd12b56d6febd2aeb86a141272d1fe3904cb6421933168e98e8ba6aa"
  head "https://github.com/kulp/tenyr.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "8acd61335c5fa25698b1593649bb3102fb034b9d4f61826b91495877fcceb8ac" => :high_sierra
    sha256 "d2f1bdbad0ab62d0bad8febca4de963414760ff4acd515974ae3e36067d77c5e" => :sierra
    sha256 "45713c09432fd87341e37a8e4685364e5f8cb435919f6dd14d9e28165757cc75" => :el_capitan
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
