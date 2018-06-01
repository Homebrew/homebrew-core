class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.8.2.tar.bz2"
  sha256 "86bed06b7115b64441d32ae53634fcc0539a50b9b648ef87443f936782f6c3ca"
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  bottle do
    cellar :any
    sha256 "702f7077266bf9c79778957136f5d620cf65d15567f28e51ade42bec12fd279d" => :high_sierra
    sha256 "5d1fd1e565c2fd767c2616dc7efe562982211475cb827d7e2af1c3c558029779" => :sierra
    sha256 "d0469f5ca859fe94907b38bae7381e7db9db94cf2f3b8cc5c76eec11c15cde69" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libsamplerate"
  depends_on "libsndfile"

  def install
    system "make", "-f", "Makefile.osx"
    bin.install "bin/rubberband"
    lib.install "lib/librubberband.dylib"
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
