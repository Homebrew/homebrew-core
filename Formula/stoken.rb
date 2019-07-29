class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8b558486eeb55f39205d26201a1613eaaadc9b6615d1e5f24b3487749acfb89b" => :mojave
    sha256 "2aeef625d9594a2fc26890500d1c8ff611e8c5c69df6f8ac905b6a72f179caf0" => :high_sierra
    sha256 "0896359e6966f067248616b2393e5e0f24a05639c4059c7f6bbd025acb867714" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
