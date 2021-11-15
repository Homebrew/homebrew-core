class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.6.4.tar.xz"
  sha256 "6ab28b4991bc6aedbd73550291360aa6ab3df41f59206a9bde9690208a6e387c"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3afb8b9256e015fcb1fc49608cea9fe6c02e6a93fa1df0a7720a30c5e8057699"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57f40e26e5b3c4239c2f247705d3b6b27256482ef67c239cb34bc82ec5cea891"
    sha256 cellar: :any_skip_relocation, monterey:       "7c86940a523d15f63966df796fdea74176c02be7adc8c4071d2f60a194bd30af"
    sha256 cellar: :any_skip_relocation, big_sur:        "c858bb88d9f4d2d00da1d7498ee130a6d134b77a07d786d9b3906b74fedc90b0"
    sha256 cellar: :any_skip_relocation, catalina:       "a1517973190e2b8fdf21136344334ad757a0bd4fe24ab65c0846a4e5e64b26df"
    sha256 cellar: :any_skip_relocation, mojave:         "a42c1376dca39a3708d3c070958e85b1dc50ddbf133b5a26055d4f314319f69c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c282a77e53c828abe22a69af0b1dd9cb124b333344f9be1b0f0f3d0a55a3fb0"
  end

  depends_on "gcc" if DevelopmentTools.clang_build_version < 1100

  # error: use of unknown builtin '__builtin_clrsb'
  fails_with :clang if DevelopmentTools.clang_build_version < 1100

  def install
    # BSD "install" does not understand the GNU -D flag.
    # Create the parent directories ourselves.
    inreplace "Makefile", "install -D", "install"
    bin.mkpath
    man1.mkpath

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
