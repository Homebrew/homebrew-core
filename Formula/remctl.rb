class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.13.tar.xz"
  sha256 "e8f249c5ef54d5cff95ae503278d262615b3e7ebe13dfb368a1576ef36ee9109"

  bottle do
    sha256 "4b9aef69010313dc6429cc6a47ef51e40cd61d31eb98d2bb6e32c22a95f2bff3" => :sierra
    sha256 "23f441a3c0a54354aaa4b73ecd1c6b6f041d8232d38198db47ff11e788dd2b9e" => :el_capitan
    sha256 "78587e49de505753c9f842a6bb1705d4652f1f9f7c875e1e0a329a62413db839" => :yosemite
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
