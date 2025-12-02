class VampPluginSdk < Formula
  desc "Audio processing plugin system sdk"
  homepage "https://www.vamp-plugins.org/"
  # curl fails to fetch upstream source, using Debian's instead
  url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/vamp-plugin-sdk_2.10.0.orig.tar.gz"
  mirror "https://code.soundsoftware.ac.uk/attachments/download/2691/vamp-plugin-sdk-2.10.0.tar.gz"
  sha256 "aeaf3762a44b148cebb10cde82f577317ffc9df2720e5445c3df85f3739ff75f"
  license all_of: ["X11", "BSD-3-Clause"]
  revision 1
  head "https://code.soundsoftware.ac.uk/hg/vamp-plugin-sdk", using: :hg

  # code.soundsoftware.ac.uk has SSL certificate verification issues, so we're
  # using Debian in the interim time. If/when the `stable` URL returns to
  # code.soundsoftware.ac.uk, the previous `livecheck` block should be
  # reinstated: https://github.com/Homebrew/homebrew-core/pull/75104
  livecheck do
    url "https://deb.debian.org/debian/pool/main/v/vamp-plugin-sdk/"
    regex(/href=.*?vamp-plugin-sdk[._-]v?(\d+(?:\.\d+)+)\.orig\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bb7224a25dadc8224c09bee6594dcd2003a0d8a9f43f3bc392d889923ffb539"
    sha256 cellar: :any,                 arm64_sequoia: "0fd18a6d81ea391818744555984ec3b2f8052f801a097be6511dc4589d9810fc"
    sha256 cellar: :any,                 arm64_sonoma:  "1ba7dd45b17c25c2eecfa787ee7ca90509534e91492351c5237acd33be37b3b7"
    sha256 cellar: :any,                 arm64_ventura: "000ee83ec09f5d546c480315b154076d94e56006892509f8bf31796d9361331d"
    sha256 cellar: :any,                 sonoma:        "046ceaa07d234cb1e8bb83998f35a0a9d8188e0a650c5f56b89556ca2926cc95"
    sha256 cellar: :any,                 ventura:       "db668adf1c325b7714a5212f2c8aaf55f6eed7cf9486e58a4573334a13555812"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9db23c618723a54ba3fdf8481efeb39a46aed83c59c699eebb5e78e888f4aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9cb9dabefa0df5e50224c77c88a1b892f59fecbad8f987ac2cc94a87fd09a55"
  end

  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "vamp-sdk/Plugin.h"
      #include <vamp-sdk/PluginAdapter.h>

      class MyPlugin : public Vamp::Plugin { };

      const VampPluginDescriptor *
      vampGetPluginDescriptor(unsigned int version, unsigned int index) { return NULL; }
    CPP

    flags = if OS.mac?
      ["-Wl,-dylib"]
    else
      ["-shared", "-fPIC"]
    end

    system ENV.cxx, "test.cpp", "-I#{include}", *flags, "-o", shared_library("test")
    assert_match "Usage:", shell_output("#{bin}/vamp-rdf-template-generator 2>&1", 2)

    cp "#{lib}/vamp/vamp-example-plugins.so", testpath/shared_library("vamp-example-plugins")
    ENV["VAMP_PATH"]=testpath
    assert_match "amplitudefollower", shell_output("#{bin}/vamp-simple-host -l")
  end
end
