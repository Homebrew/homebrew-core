class Solid < Formula
  desc "Collision detection library for geometric objects in 3D space"
  homepage "https://github.com/dtecta/solid3/"
  url "https://github.com/dtecta/solid3/archive/ec3e218616749949487f81165f8b478b16bc7932.tar.gz"
  version "3.5.8"
  sha256 "e3a23751ebbad5e35f50e685061f1ab9e1bd3777317efc6912567f55259d0f15"
  license any_of: ["GPL-2.0-only", "QPL-1.0"]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d60b8794f39a07abe48ee17d5d5d71de75ee92f8d39dc81fe32bb31b12020558"
    sha256 cellar: :any,                 arm64_sequoia:  "a120341c8125672e287c5273d0aa022bc1751270b12b94d24aaad75efb8e86f8"
    sha256 cellar: :any,                 arm64_sonoma:   "275a045468641fdf508d008c04970a996245aeaf7339f00a6c6c8ebbfbd4f800"
    sha256 cellar: :any,                 arm64_ventura:  "abc0a05c054df066acb09a0303e2af828758236acf0da8ddaa29c18e0d0f670f"
    sha256 cellar: :any,                 arm64_monterey: "e670e041979d6f3f95ded01c38b053a701d55dee074e016197ba1b1613128d67"
    sha256 cellar: :any,                 arm64_big_sur:  "ec2f44a3fe6993dd89a03fc6c79bb15ea9d0e03eff14c5fee248a8d6ef2dc84b"
    sha256 cellar: :any,                 sonoma:         "e53aa3117c1e597cb122e90029527b58a5e5aed4d0d19efe743fe75052662043"
    sha256 cellar: :any,                 ventura:        "b8cd0d00412c2bdc847bae1471f35cefa9542c8ee380ec8ef0d5c736c85b1ed4"
    sha256 cellar: :any,                 monterey:       "5f6332325f0e43bd790343ac713ffde38b6933284f56ccf2300ed1f6a0d846c1"
    sha256 cellar: :any,                 big_sur:        "53fa124eaf6eec06348f0fd19db0cf189066560f44ed22f6fffb9bdbc58beae7"
    sha256 cellar: :any,                 catalina:       "9d1231c8c37bb4a40ae017d0f8a546bf8f58a2c8f4898d9c226a8aec1708d633"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4834bad27ab6bcb57d0fdd0bec5983e526a8cb1d340b2f9cb6ba6df8bd163764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf61db5178e9b3286d47dee7ec43fbb18da035dd2bfad28d269e74aa01ff7d1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # This patch fixes a broken build on clang-600.0.56.
  # Was reported to bugs@dtecta.com (since it also applies to solid-3.5.6)
  patch :DATA

  def install
    # Avoid `required file not found` errors
    touch ["AUTHORS", "ChangeLog", "NEWS"]

    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--infodir=#{info}", *std_configure_args

    # Don't make examples, as they do not compile because the include
    # statements for the GLUT library are not platform independent
    inreplace "Makefile", /^(SUBDIRS *=.*) examples( .+)?/, '\1\2'

    system "make", "install"
  end
end

__END__
diff --git a/src/complex/DT_CBox.h b/src/complex/DT_CBox.h
index 7fc7c5d..16ce972 100644
--- a/src/complex/DT_CBox.h
+++ b/src/complex/DT_CBox.h
@@ -131,4 +131,6 @@ inline DT_CBox operator-(const DT_CBox& b1, const DT_CBox& b2)
                    b1.getExtent() + b2.getExtent());
 }

+inline DT_CBox computeCBox(MT_Scalar margin, const MT_Transform& xform);
+
 #endif
