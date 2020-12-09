class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8/sipsak-0.9.8.tar.gz"
  sha256 "c506e6eebcde678be224230858564a21dc2b58114a723a726c0b263832ca2546"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "c5d5192b5f6aae341d6b6124edda2962b7d1b70822c312b5684351a89fffdc84" => :big_sur
    sha256 "84d9694858c95f7ce07829e602be3d9727b00602ea69bf8e191f79f399f53597" => :catalina
    sha256 "5da0bb6fc866723e423714b275cbc6c64ac1e57f171cfe112bda6f9779385ae3" => :mojave
    sha256 "6cc0007fe520e225bc0a6b9b646817468acbc1383cb6a4382ae8bf1243ae3e5b" => :high_sierra
    sha256 "0d074a6356f127485211b79741fd7f45e7ed9435e4d708e539088a9e9154daea" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end
