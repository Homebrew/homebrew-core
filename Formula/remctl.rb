class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.13.tar.xz"
  sha256 "e8f249c5ef54d5cff95ae503278d262615b3e7ebe13dfb368a1576ef36ee9109"
  revision 1

  bottle do
    sha256 "edfe97b717e944a87d29abe653d9ffafee8c1b70f5809d94434bf9d5b9430725" => :sierra
    sha256 "ca265d9856564ddc2b72f671760be7d06a16718ec7f16cf8c6a548eaa83fcb8d" => :el_capitan
    sha256 "85aca4fa0248cdf724a304ba559144c69b487d25e1870d9b89bb52558bd34b6b" => :yosemite
  end

  depends_on "pcre"
  depends_on "libevent"

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
