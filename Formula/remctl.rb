class Remctl < Formula
  desc "Client/server application for remote execution of tasks"
  homepage "https://www.eyrie.org/~eagle/software/remctl/"
  url "https://archives.eyrie.org/software/kerberos/remctl-3.15.tar.xz"
  sha256 "873c9fbba51ff721acb666e927f58f4407f08eb79f53b5a058801f5f404f4db2"
  revision 1

  bottle do
    cellar :any
    sha256 "d5e08fbf392f82c5742a1118e015f9e621e9b0b788b501c0a679215f29819490" => :mojave
    sha256 "2d742860ccb08ab27df64eb318e424a1d5d8432ebf60a77fb623cfe844413a31" => :high_sierra
    sha256 "d344cfccbaf89d8d8612692ba44521b5fa1d19a4e0e13b14e6efd12e7ef35442" => :sierra
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
