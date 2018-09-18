class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"

  bottle do
    cellar :any
    sha256 "3a362165a5fac3e9c9117f0f247449aad1c1c6dfa76dfd6dfd652ed5137d7c09" => :mojave
    sha256 "cb6b6bb8d97abca20a4395fe9686717186ad1e4fc99f470e74a3b7748bde4d4d" => :high_sierra
    sha256 "005b85ff93aa190fbe9590324b1579d960c3207cd144cf860cfc6050eaf10e71" => :sierra
    sha256 "f29de39d399ca3b9acbdae0e170e82173f2fbcd5806663a8697c10695b5d1b82" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"
  depends_on "gtk+3" => :optional

  if build.with? "gtk+3"
    depends_on "adwaita-icon-theme"
    depends_on "hicolor-icon-theme"
  end

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
