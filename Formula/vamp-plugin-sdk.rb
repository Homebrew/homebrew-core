class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  url "https://code.soundsoftware.ac.uk/attachments/download/2588/vamp-plugin-sdk-2.9.0.tar.gz"
  sha256 "b72a78ef8ff8a927dc2ed7e66ecf4c62d23268a5d74d02da25be2b8d00341099"
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", :using => :hg

  bottle do
    cellar :any
    sha256 "8d1721898748dfa819a8c4810d7bf4eae9556590e212ad70ee39c549b0ca3898" => :catalina
    sha256 "4b981b6981e8e975fd8258462d6d5f7046f59d45f3aade1bab1921ef4190de2e" => :mojave
    sha256 "4668af0624dd0d5cb4bb3c4c09ccc33930807b8d14d576e20ddcd3e12f368acf" => :high_sierra
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
