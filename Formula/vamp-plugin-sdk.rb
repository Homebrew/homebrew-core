class VampPluginSdk < Formula
  desc "audio processing plugin system sdk"
  homepage "http://www.vamp-plugins.org"
  url "https://code.soundsoftware.ac.uk/attachments/download/2206/vamp-plugin-sdk-2.7.1.tar.gz"
  sha256 "c6fef3ff79d2bf9575ce4ce4f200cbf219cbe0a21cfbad5750e86ff8ae53cb0b"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", :using => :hg

  bottle do
    cellar :any
    sha256 "3a2e87cfd4ba5c0eb9675ad4a0cb2fd412315bd71f81cde9d5fd0648bafdd08c" => :sierra
    sha256 "3c1665b45ed9060ddcc00036b760e48e2d8f884877a8976bfb5d5bb8b8dc09b0" => :el_capitan
    sha256 "9f9faa350b6a0072264107506a243cc627459da143e41b1cde8af2cad1b52079" => :yosemite
    sha256 "86a5d017be8bccf01f43b6e99fb2f441bde4dc6edff36837d58467926563e4f7" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libsndfile"
  depends_on "libogg"
  depends_on "flac"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
