class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://downloads.sourceforge.net/project/rdesktop/rdesktop/1.8.3/rdesktop-1.8.3.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/r/rdesktop/rdesktop_1.8.3.orig.tar.gz"
  sha256 "88b20156b34eff5f1b453f7c724e0a3ff9370a599e69c01dc2bf0b5e650eece4"
  revision 1

  bottle do
    sha256 "9a0d85e617805161eb6f06359a8c72af0d6b45d6316986307ad036022d8ff8d8" => :mojave
    sha256 "d43503deba0816e2290a9ef69a0e618015c003421f0ba60af24e83e1a62b5316" => :high_sierra
    sha256 "9a8e06ed924645367b0dbb7e1668ce0925746c6e88a7bc0bc0fb184c0b955461" => :sierra
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
