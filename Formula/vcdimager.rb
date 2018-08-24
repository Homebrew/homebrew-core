class Vcdimager < Formula
  desc "(Super) video CD authoring solution"
  homepage "https://www.gnu.org/software/vcdimager/"
  url "https://ftp.gnu.org/gnu/vcdimager/vcdimager-2.0.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/vcdimager/vcdimager-2.0.1.tar.gz"
  sha256 "67515fefb9829d054beae40f3e840309be60cda7d68753cafdd526727758f67a"

  bottle do
    cellar :any
    sha256 "1dada6e9157e7e89d903a2cbc82ec12199ad7afb8384af90a4601bd99d4b18fd" => :mojave
    sha256 "a990e94922c3b6e779907c421cf9aafc10d2f5bce3196580d0274909a18f6cb7" => :high_sierra
    sha256 "e78e0d7842f71d68f5ef23ea13c64a04c012a523e0759b78a1395a21281c7b73" => :sierra
    sha256 "9094f54dbd4234a5fb6bd23ab39c2b4f87f7bebb5ccfb398942fb98df37813b0" => :el_capitan
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
