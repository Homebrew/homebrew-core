class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.16.tar.xz"
  sha256 "d1c444ab6c817c82413ec9686d178b9d760cd684eae7d24782bbe5c9ce5b0908"

  livecheck do
    url "https://archives.eyrie.org/software/kerberos/"
    regex(/href=.*?remctl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "0c94a53cbd26ed882a5b4c8f973562120dd1cf0a6f76457d392cc5fe59d5ee89" => :catalina
    sha256 "3472db7e7bd12cb03c12b6dc2db8168439a24eef73bde7fbec775a41db628042" => :mojave
    sha256 "777fb3b5f47e4da6caeacba3c4959a38ebf7113a89555aebe74d41854c70104a" => :high_sierra
  end

  depends_on "libevent"
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-pcre=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system "#{bin}/remctl", "-v"
  end
end
