class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.3/rdesktop-1.8.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rdesktop/rdesktop_1.8.3.orig.tar.gz"
  sha256 "88b20156b34eff5f1b453f7c724e0a3ff9370a599e69c01dc2bf0b5e650eece4"
  revision 1

  bottle do
    sha256 "f9594ed7f111a6422773469b9ed7e6b3bf31d1f5cab6eff297f4a8be739427fc" => :mojave
    sha256 "7a70e9cd3c541121b9ae55eabb7036f34c3818a952ab5104365bd6437ebb9420" => :high_sierra
    sha256 "2a09f53bccef981e542de0c2a3066ccb6e438fe0c11341281cb2803ce09f7bb8" => :sierra
    sha256 "46b1a3070669d5f0e2f1e70e387ae4a3c7d956a0991378138ab5de39e6be3b9e" => :el_capitan
    sha256 "923ab34a5daaab70f97aa23c8cebc91cba3a776584d35444eadf123050471d5f" => :yosemite
  end

  depends_on "openssl"
  depends_on :x11

  # Note: The patch below is meant to remove the reference to the
  # undefined symbol SCARD_CTL_CODE.
  # upstream bug report: https://sourceforge.net/p/rdesktop/bugs/352/
  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-credssp
      --enable-smartcard
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --x-includes=#{MacOS::X11.include}
      --x-libraries=#{MacOS::X11.lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rdesktop -help 2>&1", 64)
  end
end

__END__
diff --git a/scard.c b/scard.c
index caa0745..5521ee9 100644
--- a/scard.c
+++ b/scard.c
@@ -2152,7 +2152,6 @@ TS_SCardControl(STREAM in, STREAM out)
	{
		/* Translate to local encoding */
		dwControlCode = (dwControlCode & 0x3ffc) >> 2;
-		dwControlCode = SCARD_CTL_CODE(dwControlCode);
	}
	else
	{
@@ -2198,7 +2197,7 @@ TS_SCardControl(STREAM in, STREAM out)
	}

 #ifdef PCSCLITE_VERSION_NUMBER
-	if (dwControlCode == SCARD_CTL_CODE(3400))
+	if (0)
	{
		int i;
		SERVER_DWORD cc;
