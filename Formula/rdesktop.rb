class Rdesktop < Formula
  desc "UNIX client for connecting to Windows Remote Desktop Services"
  homepage "https://www.rdesktop.org/"
  url "https://github.com/rdesktop/rdesktop/releases/download/v1.8.6/rdesktop-1.8.6.tar.gz"
  sha256 "4131c5cc3d6a2e1a6515180502093c2b1b94cc8c34dd3f86aa8b3475399634ef"
  revision 1

  bottle do
    sha256 "748c0fe4a854917a3403b084c9ce0843515f7ac9e522619d6f880f3a55c01908" => :catalina
    sha256 "c319fc2fceca931b83d5b05f6e2d9c1ae4687a277b1c71e4e5cb73e424759ef8" => :mojave
    sha256 "92a663dd356df68f0b86ec58e1f3f07d242aa6c66fda7c90dc41330b793f2c4d" => :high_sierra
    sha256 "c3514986d81f0b8c9e4e37e2dc6648ce4978d814dff3c5e187a9ead35fdadf0d" => :sierra
  end

  depends_on "openssl@1.1"
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
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
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
