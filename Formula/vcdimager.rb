class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"
  revision 1

  bottle do
    cellar :any
    sha256 "cc883a163479f28c7303fcd378eba5461fabeafa5970bbb55695fb097cc2f3e0" => :catalina
    sha256 "cb45bd1a48e551a60e8b344668a79e24414012ebc76a141ee6c0677ec21ad594" => :mojave
    sha256 "993b40efcd1af1844ed14064de2551cecbdacc3a1c4d39f9fe1d8b289b3b6eb9" => :high_sierra
    sha256 "2e8567e154610bb1c3c29a50c6fc9f150ddf84c36d6c94fc35a1f8ab3a495f13" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"
  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"vcdimager", "--help"
  end
end
