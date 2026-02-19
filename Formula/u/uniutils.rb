class Uniutils < Formula
  desc "Manipulate and analyze Unicode text"
  homepage "https://billposer.org/Software/unidesc.html"
  url "https://billposer.org/Software/Downloads/uniutils-2.28.tar.gz"
  sha256 "41c14c0223376f2d96c80c2ba1b1494fc74cd8982d561630e688e2245aaf3364"
  license all_of: [
    "GPL-2.0-or-later",
    "GPL-3.0-only",
  ]

  livecheck do
    url :homepage
    regex(/href=.*?uniutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "c8c2a6ab2e7fd876281c9b107d275f17ab9620a3241a664cdd11af7f02d08fc2"
    sha256 cellar: :any,                 arm64_sequoia:  "b1e77b1c7bb772f82fa4f847d6d08f8b7b4da149516636d45ec0aaa662937490"
    sha256 cellar: :any,                 arm64_sonoma:   "d2e0b6cb5b9a69c9c3b7741b22d800538287c470d377c7796487146cb7875f33"
    sha256 cellar: :any,                 arm64_ventura:  "a7487de087156bf2db6b8db4966e4d8864a822c21da7c07d9c740a17be5771b9"
    sha256 cellar: :any,                 arm64_monterey: "3c4ddbab225f52bd4b6b2b46f35a3a01f827f52367b3cf709251c7eeda260ede"
    sha256 cellar: :any,                 sonoma:         "6cb5418da4466190223532647f17da877e3af7d19fe61fce7f56fc1465e47c25"
    sha256 cellar: :any,                 ventura:        "6ec87153855511c01c9ec16b2d917c8e80517b3a5da69f74b34f2e40f540b1dc"
    sha256 cellar: :any,                 monterey:       "432cba754fdf29b6e4e99e43a45f4340047dbe3042038ab8c2de173c7bfdc596"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2ff9239b9e70ce2c37680c210c047c0b8d7b88b68058550a267b98643c1f358c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35edd0447764ae2524bba5bf3eb9178d70a5a3559b4c896e8ac8bfaf65f2466"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_macos do
    depends_on "gettext" # for libintl
  end

  # Allow build with clang. This patch was reported to debian here:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740968
  # And emailed to the upstream source at billposer@alum.mit.edu
  patch :DATA

  def install
    # fix `./install-sh: Permission denied` issue
    system "autoreconf", "--force", "--install", "--verbose"

    # workaround for Xcode 14.3
    if DevelopmentTools.clang_build_version >= 1403
      ENV.append "CFLAGS", "-Wno-implicit-function-declaration -Wno-implicit-int"
    end

    # fix `_libintl_bindtextdomain` and `_libintl_textdomain` symbols not found
    gettext = Formula["gettext"]
    ENV.append "CFLAGS", "-I#{gettext.include}"
    ENV.append "LDFLAGS", "-L#{gettext.lib}"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?

    system "./configure", "--disable-silent-rules", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    s = pipe_output("#{bin}/uniname", "ü")
    assert_match "LATIN SMALL LETTER U WITH DIAERESIS", s
  end
end

__END__
Description: Fix clang FTBFS [-Wreturn-type]
Author: Nicolas Sévelin-Radiguet <nicosr@free.fr>
Last-Update: 2014-03-06
--- a/unifuzz.c
+++ b/unifuzz.c
@@ -97,7 +97,7 @@
 }

 /* Emit the middle character from each range */
-EmitAllRanges(short AboveBMPP) {
+void EmitAllRanges(short AboveBMPP) {
   int i;
   UTF32 scp;
   extern int Ranges_Defined;
