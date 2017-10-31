class Tnftp < Formula
  desc "This is the FTP client that used to be included in MacOS prior to High Sierra"
  homepage "http://freecode.com/projects/tnftp"
  url "ftp://ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftp-20091122.tar.gz"
  sha256 "ad834fa8776d6be87aa438c554869301173a0808919c65a84dccea6c5ec9d286"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/tnftp about:version", 0)
    assert_match "Version: tnftp 20091122", output
  end
end
