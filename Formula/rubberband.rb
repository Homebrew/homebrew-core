class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.9.0.tar.bz2"
  sha256 "4f5b9509364ea876b4052fc390c079a3ad4ab63a2683aad09662fb905c2dc026"
  license "GPL-2.0-or-later"
  head "https://hg.sr.ht/~breakfastquay/rubberband", using: :hg

  livecheck do
    url :homepage
    regex(/Rubber Band Library v?(\d+(?:\.\d+)+) released/i)
  end

  bottle do
    cellar :any
    sha256 "f5b7d05107fadeca115e0ab09130178ede93fb6f0e18c7b392bdd77e3587b966" => :big_sur
    sha256 "b7436d1a91b540cc384f15f3c4416f229635c5412b5939ae0037ceb8158bf451" => :arm64_big_sur
    sha256 "4598d98fb8994cd6545f5858a38beae10b43968317b53ec0916542d95355f27c" => :catalina
    sha256 "487182397781621580ecb07f51d301d84b46c6f2f8458880cb8213044f5181cb" => :mojave
    sha256 "15082ba72d1f88258739752b4f4a8094d5f931fac1d69aa64d8bf25ecb21648d" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  on_linux do
    depends_on "fftw"
    depends_on "ladspa-sdk"
    depends_on "openjdk"
    depends_on "vamp-plugin-sdk"
  end

  def install
    # Pass OPTFLAGS and ARCHFLAGS to avoid Intel-specific flags
    system "make", "-f", "Makefile.osx",
                   "OPTFLAGS='-DNDEBUG -ffast-math -O3 -ftree-vectorize'",
                   "ARCHFLAGS="

    # HACK: Manual install because "make install" is broken
    # https://github.com/Homebrew/homebrew-core/issues/28660
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib" => "librubberband.2.1.1.dylib"
    lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.2.dylib"
    lib.install_symlink lib/"librubberband.2.1.1.dylib" => "librubberband.dylib"
    include.install "rubberband"

    cp "rubberband.pc.in", "rubberband.pc"
    inreplace "rubberband.pc", "%PREFIX%", opt_prefix
    (lib/"pkgconfig").install "rubberband.pc"
  end

  test do
    output = shell_output("#{bin}/rubberband -t2 #{test_fixtures("test.wav")} out.wav 2>&1")
    assert_match "Pass 2: Processing...", output
  end
end
