class Rubberband < Formula
  desc "Audio time stretcher tool and library"
  homepage "https://breakfastquay.com/rubberband/"
  url "https://breakfastquay.com/files/releases/rubberband-1.8.2.tar.bz2"
  sha256 "86bed06b7115b64441d32ae53634fcc0539a50b9b648ef87443f936782f6c3ca"
  head "https://bitbucket.org/breakfastquay/rubberband/", :using => :hg

  bottle do
    cellar :any
    rebuild 1
    sha256 "b05e8e38194a9b067ccfa2df621d4f36b7d4bb24b0fb61bd2dc430b5bf5b7ddc" => :high_sierra
    sha256 "fd0d92643b23e338992204be763362480ffd8ee54c407908bf0dcd589d066b68" => :sierra
    sha256 "ec6ec212a0173ba661601b2fb5ae1dace5dab1100688d3b5c9a460796eae705b" => :el_capitan
    sha256 "6a62c8da1d779672bf0ef276656b2dfa5edf885e704a875c606a27b9aea863fe" => :yosemite
    sha256 "5ca9579f1b84a3a843e5b52654f41b25e4c02fdc5df05a0966c6d8627843dac4" => :mavericks
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
