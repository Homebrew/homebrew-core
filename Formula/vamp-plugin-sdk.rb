class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  url "https://code.soundsoftware.ac.uk/attachments/download/2691/vamp-plugin-sdk-2.10.0.tar.gz"
  sha256 "aeaf3762a44b148cebb10cde82f577317ffc9df2720e5445c3df85f3739ff75f"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", using: :hg

  bottle do
    cellar :any
    sha256 "b31926ceedbd7f79dc9783da8092b543c549d800705d9d8e8d8d0fd451d093de" => :catalina
    sha256 "ee8d69d0b8c72e3e9ed1c79bfa7ca6650d10e36a2b110215b3d803f841ae2ec0" => :mojave
    sha256 "834812edc745c782511f1397fb5e3e6995b9fd25b42426ec784cd5610dbc9eb4" => :high_sierra
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
