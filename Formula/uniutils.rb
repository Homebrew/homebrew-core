class Uniutils < Formula
  desc "Manipulate and analyze Unicode text"
  homepage "https://billposer.org/Software/unidesc.html"
  url "https://billposer.org/Software/Downloads/uniutils-2.27.tar.gz"
  sha256 "c662a9215a3a67aae60510f679135d479dbddaf90f5c85a3c5bab1c89da61596"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2991a6dc15937fd36591ef3a56134d9474b544a3d0f9407a9555adebf3a53e7" => :catalina
    sha256 "2ea235c47ef4ede643ccb1adaccbc376b0cbe39bbdeb3d5623bcbea210cd7519" => :mojave
    sha256 "6717501e797865b956ded03f433b9353e033328727bcdd6263b1f3721c8ef30d" => :high_sierra
    sha256 "5f6609e92596f48fbb20bd0245437f4e967ebc9d06d9fc5e130584f394dce21a" => :sierra
    sha256 "9e83bffe9268c4be17f6e37254da13d2edfeee19869bd075580eeaa8f770078b" => :el_capitan
    sha256 "8707e4003370e82a9dc93f928f35f7160b4fa52d6954df916f292020bf9a790b" => :yosemite
  end

  # Allow build with clang. This patch was reported to debian here:
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=740968
  # And emailed to the upstream source at billposer@alum.mit.edu
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    s = pipe_output("#{bin}/uniname", "ü")
    assert_match /latin small letter u with diaeresis/i, s
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
