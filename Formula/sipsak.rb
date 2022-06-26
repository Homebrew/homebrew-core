class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://github.com/nils-ohlmeier/sipsak/releases/download/0.9.8.1/sipsak-0.9.8.1.tar.gz"
  sha256 "c6faa022cd8c002165875d4aac83b7a2b59194f0491802924117fc6ac980c778"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f2f4bf2277f852ef0efc351e36ff629a9f17d9779656e9c5f15022571b6a8350"
    sha256 cellar: :any,                 arm64_big_sur:  "4525ec303fc0f5ffd3b752ccf1dcdc7fdb14921ad35d8e12109e257c47ce14fc"
    sha256 cellar: :any,                 monterey:       "3a220f3f6e45c89f05948970e5bfd8ee64030674e50dea30f4713173abcc3a25"
    sha256 cellar: :any,                 big_sur:        "70442c0b739c1fb357e8eef8246d56425fdde5f094bfe8048304cc2b42fbfe0b"
    sha256 cellar: :any,                 catalina:       "3d7c198e46fd2e183d199718d175111e9024d4ea8f453685fe973e76c342f988"
    sha256 cellar: :any,                 mojave:         "9f27279cd8a53e5d707d7208ba2ba5f5170dd775854f30396135a296dd9c55dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a953aef939a2e020ceb548db309d98462b4b2ca0ea2e9f70c0f298a7f0dbd3c"
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
