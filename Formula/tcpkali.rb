class Tcpkali < Formula
  desc "High performance TCP and WebSocket load generator and sink"
  homepage "https://github.com/machinezone/tcpkali"
  url "https://github.com/machinezone/tcpkali/releases/download/v0.9/tcpkali-0.9.tar.gz"
  sha256 "4acb38bd1a2421f247afbd07e67d47aaa8bb848f92e7badd2cd581022406d855"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d8d1ef4e650647919f4f38e690fb918474be00a45da85f93d001ae914eb5870" => :el_capitan
    sha256 "6bd81cef0a0671a3baddaeef3600d78d2db6ecf66e41bdb68d34068a0913ff4b" => :yosemite
    sha256 "573d2ddb670aacbd2379136d96d7ee80822786ddc9100409d8006df32bae229b" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpkali", "-l1237", "-T0.5", "127.1:1237"
  end
end
