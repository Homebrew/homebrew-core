class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.13.tar.xz"
  sha256 "e8f249c5ef54d5cff95ae503278d262615b3e7ebe13dfb368a1576ef36ee9109"

  bottle do
    sha256 "b509ae099d9f39a5c9beecec9397ca5edd55e632bc4a94f5e896fb27016f2621" => :el_capitan
    sha256 "766b3a13fdc77e8a98fb1989fb549f068475b80d675ab1341d993b9294d66010" => :yosemite
    sha256 "5035361df688340431fbce01ea01d9ae0e5945a46d4ae4e0f0d059037fb8ed5f" => :mavericks
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
