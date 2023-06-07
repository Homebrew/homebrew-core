class Uniutils < Formula
  desc "Manipulate and analyze Unicode text"
  homepage "https://billposer.org/Software/unidesc.html"
  url "https://billposer.org/Software/Downloads/uniutils-2.27.tar.gz"
  sha256 "c662a9215a3a67aae60510f679135d479dbddaf90f5c85a3c5bab1c89da61596"
  license "GPL-3.0"

  livecheck do
    url :homepage
    regex(/href=.*?uniutils[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae4dc0b70cd3f5567f0c3a23d595be9f98d840c2437d3080abd25ef1241837a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "211d63bf402c81b1ff57f098a7bd517090a35f47374c2d92fa6234678bcb613f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cb5a86b69e6efe758a353744ac48a0ec1777f3b1ed814848906d6365ad7ba81"
    sha256 cellar: :any_skip_relocation, ventura:        "09de82560f248a53ea2d1a34532f61e4b19250162e930e3743ef7bab37d6ff50"
    sha256 cellar: :any_skip_relocation, monterey:       "eece3849b5ed4da3c2ff4a850338a523cfc8fe2d64c7f663147e17d673c410aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "df42759537263cec13ae2662eac1de96d0692b34e146eff756dbb52b79c7c5d7"
    sha256 cellar: :any_skip_relocation, catalina:       "c2991a6dc15937fd36591ef3a56134d9474b544a3d0f9407a9555adebf3a53e7"
    sha256 cellar: :any_skip_relocation, mojave:         "2ea235c47ef4ede643ccb1adaccbc376b0cbe39bbdeb3d5623bcbea210cd7519"
    sha256 cellar: :any_skip_relocation, high_sierra:    "6717501e797865b956ded03f433b9353e033328727bcdd6263b1f3721c8ef30d"
    sha256 cellar: :any_skip_relocation, sierra:         "5f6609e92596f48fbb20bd0245437f4e967ebc9d06d9fc5e130584f394dce21a"
    sha256 cellar: :any_skip_relocation, el_capitan:     "9e83bffe9268c4be17f6e37254da13d2edfeee19869bd075580eeaa8f770078b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cf517fda500768eb4c44d1595e4f49bd4b9bb20c94981a11db42ac8aded62d7"
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
