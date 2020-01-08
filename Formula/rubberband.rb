class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.8.2.tar.bz2"
  sha256 "86bed06b7115b64441d32ae53634fcc0539a50b9b648ef87443f936782f6c3ca"
  revision 1
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  bottle do
    cellar :any
    sha256 "fb34979b7ddd85883800f6bb3822202e15baab0f18781cb6deaf64482bf0c894" => :catalina
    sha256 "e100d79a7c55a6ba5642d0ce9e005971bdab26e8b7a0cdec011e21db19ccd767" => :mojave
    sha256 "7dd91b6d0baee3f08704fb8dae4ced59725ef23a921dbf00c4db3a39f2119c63" => :high_sierra
    sha256 "3fead448ab4b7e72a624cf85e82b0d1965ea8be224b95f43a24f56c248b9ec1e" => :sierra
    sha256 "965110230f35d93876ec006522145b35a2e8168bb0202e7666d786f1e8262ce1" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.osx"
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
