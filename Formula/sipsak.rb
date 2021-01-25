class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8.1/sipsak-0.9.8.1.tar.gz"
  sha256 "c6faa022cd8c002165875d4aac83b7a2b59194f0491802924117fc6ac980c778"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "70442c0b739c1fb357e8eef8246d56425fdde5f094bfe8048304cc2b42fbfe0b" => :big_sur
    sha256 "4525ec303fc0f5ffd3b752ccf1dcdc7fdb14921ad35d8e12109e257c47ce14fc" => :arm64_big_sur
    sha256 "3d7c198e46fd2e183d199718d175111e9024d4ea8f453685fe973e76c342f988" => :catalina
    sha256 "9f27279cd8a53e5d707d7208ba2ba5f5170dd775854f30396135a296dd9c55dd" => :mojave
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
