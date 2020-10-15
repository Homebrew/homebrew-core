class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "423dbce4e76710fe932fc4d86fa25b39ced8f138d781fcccbc3982ce83136216" => :catalina
    sha256 "59ee230b63a707bf9c1fd966ec003c14ca16c7e61a331b765e31a1ba4b7db867" => :mojave
    sha256 "6c6b704e5f9830e0192383c53717f64b0af48119d6f0d96d78de521820a6c84b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"

  uses_from_macos "libxml2"

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
