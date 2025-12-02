class Stk < Formula
  desc "Sound Synthesis Toolkit"
  homepage "https://ccrma.stanford.edu/software/stk/"
  url "https://ccrma.stanford.edu/software/stk/release/stk-5.0.1.tar.gz"
  sha256 "afc35faea3bb8baacacb8d9db3fa745e4f7d8dd46f36aac5436ca377d565a184"
  license "MIT"

  livecheck do
    url "https://ccrma.stanford.edu/software/stk/download.html"
    regex(/href=.*?stk[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "33c29e2a776f2b13912844ce37fd744fc1b4f0866f134b2a3ec62bd7d5333fc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "140113c25ddb581acbd291f3671b2657562ff8237c62abe8db42ba2e3e3297f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b50969de86e485eb0ea91411ecfa5ef8c531fa5da68a0d8f1df49c196339aed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cf614b99101345ec67c8bf4d63bee7b765ce0025cff30b9e61487b112768437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55edfca37504873b9b03ee40c0b369a804c6623b33e0e46937f4c97f9513efe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5755ac96f6b41e1cb2b94c4e112fad6ce671ce4bdb146fa1324e923f9e092bf0"
    sha256 cellar: :any_skip_relocation, sonoma:         "68cf2df4d1e9ba32def2c769a1a82933b4b4a93c609b42531a2fcb4874cbd577"
    sha256 cellar: :any_skip_relocation, ventura:        "18f8a96c836e1e8f9431e9940314f18774492625bc1c51813ebc029b57cd8eca"
    sha256 cellar: :any_skip_relocation, monterey:       "9f175bb0213ef53e309396354a64c1cc400728a4023cd7d153d67124cfbddeb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2dc36b8b8616a0f43bff5137e924c63606ab52509329f1e2df8d4b75aea28f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d940bdd5baa984fa5773f4e3a88fbadc294cbbad08cb13cd802fcfae2c93fba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64cfa5d539dc990021c45a9848fc8d34252138791ffb7f3a1bba0dd13d76489c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    system "./configure", *std_configure_args.reject { |s| s["--disable-dependency-tracking"] }
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

        #include "stk/FileLoop.h"
        #include "stk/FileWvOut.h"

      src/ projects/ and rawwaves/ have all been copied to #{opt_pkgshare}
    EOS
  end

  test do
    assert_equal "xx No input files", shell_output("#{bin}/treesed", 1).chomp
  end
end
