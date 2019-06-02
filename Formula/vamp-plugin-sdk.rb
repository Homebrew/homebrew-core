class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  url "https://code.soundsoftware.ac.uk/attachments/download/2450/vamp-plugin-sdk-2.8.0.tar.gz"
  sha256 "dcc96ae894795822398789f251c2c7effa602fc60e9dd6c7a5c5d2e7a513526c"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", :using => :hg

  bottle do
    cellar :any
    sha256 "9457a8641dc9dfa3dd5494cf7714b84fa577c67a1d0fdd147203cecf2421af5d" => :mojave
    sha256 "b81ef33d608958bde47122893d48582417ce580599606bf8e893a8791b9e7b0c" => :high_sierra
    sha256 "f5b77eaf0b80183cf7c19b08c4734b49393ad38e382da03666a8c8a3b5063b5d" => :sierra
    sha256 "acd0d2d514e459907217d67a6a2652bce37e6b87564fc9383a1e22763b84472a" => :el_capitan
    sha256 "ada7d84cbd975d1857e83651815a8a3a465ee04299fd32e5d90eba6646d6325c" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "vamp-sdk/Plugin.h"
      #include <vamp-sdk/PluginAdapter.h>

      class MyPlugin : public Vamp::Plugin { };

      const VampPluginDescriptor *
      vampGetPluginDescriptor(unsigned int version, unsigned int index) { return NULL; }
    EOS

    system ENV.cxx, "test.cpp", "-I#{include}", "-Wl,-dylib", "-o", "test.dylib"
    assert_match /Usage:/, shell_output("#{bin}/vamp-rdf-template-generator 2>&1", 2)

    cp "#{lib}/vamp/vamp-example-plugins.so", testpath/"vamp-example-plugins.dylib"
    ENV["VAMP_PATH"]=testpath
    assert_match /amplitudefollower/, shell_output("#{bin}/vamp-simple-host -l")
  end
end
