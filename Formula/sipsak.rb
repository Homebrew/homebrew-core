class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8.1/sipsak-0.9.8.1.tar.gz"
  sha256 "c6faa022cd8c002165875d4aac83b7a2b59194f0491802924117fc6ac980c778"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "7386f87aa1a38a6004a2bccb2f1a60f508d0c8f01f9021cf88b2938223de11d9" => :big_sur
    sha256 "492a1eb36a775220599efe23c9a4d49037cf49f8a3f4c1e8b9df4dce72c8b49e" => :arm64_big_sur
    sha256 "47c8709eafb9b97b72b22c1d01ac0e9686de5ebc2c1c57cc29c72d7bdadda2b7" => :catalina
    sha256 "7a3693652e8a56ea265a73fbc26044ee9b51f076233c154b40618bf6e8cd5c42" => :mojave
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
