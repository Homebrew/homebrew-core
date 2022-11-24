class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-4.6.2.tar.gz"
  sha256 "573e26ccf72ce436a1dc4ee3bea05fd35e0a8e742c339c7f5b85225502238083"
  license "MIT"

  livecheck do
    url "https://ccrma.stanford.edu/software/stk/download.html"
    regex(/href=.*?stk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca7a7e90edb7b136d1cd229632e33c31fe108eabd0351a3332b57a04db938ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfb08e28312687b79737423cf59db64cd30aa2d7b5527a9e65ff6d2a3d4a437c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d42d3b5288a6f8b595eb45c2f870f0494cc63e902d28a358656a4b6d3ae6b795"
    sha256 cellar: :any_skip_relocation, ventura:        "e663a628ee25dc71a782badbd50598852678eb32b249ca77424f4eae9f00187f"
    sha256 cellar: :any_skip_relocation, monterey:       "cb80d6ce6f9266932079b1edeb9acc6224335193889a873ed413a0659f8c29ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dd7c364744901db0a21e8dfc95c02545ab6bf5ef47bb9dd8a6a2866f382f5c1"
    sha256 cellar: :any_skip_relocation, catalina:       "c5857693fa1111471c746d769db8bac3486db28d7eafb3c3e61d8a680ddbce4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "767854c871ad23240582a554a26385f0980d6847d4e8012eb06ff071800cc0c1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make"

    lib.install "src/libstk.a"
    bin.install "bin/treesed"

    (include/"stk").install Dir["include/*"]
    doc.install Dir["doc/*"]
    pkgshare.install "src", "projects", "rawwaves"
  end

  def caveats
    <<~EOS
      The header files have been put in a standard search path, it is possible to use an include statement in programs as follows:

        #include \"stk/FileLoop.h\"
        #include \"stk/FileWvOut.h\"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
