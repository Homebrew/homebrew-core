class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  url "https://code.soundsoftware.ac.uk/attachments/download/2450/vamp-plugin-sdk-2.8.0.tar.gz"
  sha256 "dcc96ae894795822398789f251c2c7effa602fc60e9dd6c7a5c5d2e7a513526c"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", :using => :hg

  bottle do
    cellar :any
    sha256 "b430ba0960d22a9c954269ea60a8bea7ddb5df16c3d6525d8902fda8f7ec3d79" => :mojave
    sha256 "abb1682737521c71fda29e96cf841811f4bee42e6b56a77f9e4a1e3635106a97" => :high_sierra
    sha256 "6d14588e7f5932a267bf7ce8c3d507a2247d93a3ad363089a2d7b04ede47f2de" => :sierra
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
