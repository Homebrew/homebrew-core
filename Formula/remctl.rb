class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.15.tar.xz"
  sha256 "873c9fbba51ff721acb666e927f58f4407f08eb79f53b5a058801f5f404f4db2"

  bottle do
    sha256 "d673f05a37c5f969afbbc81453abfc34da769b5b3e21ca0ba7adbaa0201fef3d" => :high_sierra
    sha256 "6d48e0704c8803c3884e282ce2b7043dded5d2b86a49caf85f037a58a541f33f" => :sierra
    sha256 "682390632704347046e696e342a2b6127f5142391d66180e090bed90b4dc0fb0" => :el_capitan
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
