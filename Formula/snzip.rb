class Snzip < Formula
  desc "Compression/decompression tool based on snappy"
  homepage "https://github.com/kubo/snzip"
  url "https://bintray.com/artifact/download/kubo/generic/snzip-1.0.4.tar.gz"
  sha256 "a45081354715d48ed31899508ebed04a41d4b4a91dca37b79fc3b8ee0c02e25e"
  revision 2

  bottle do
    cellar :any
    sha256 "0304142d75d2495662ea2dae386948830aada6a7f653a90a74a746e56a7e9ff8" => :mojave
    sha256 "fd4c734255707e1695f5d89a6dccc7d8b6a302771a71f6f6db0a054b9655d287" => :high_sierra
    sha256 "953a79f0aa028d4b5f13cc606ead6e225c290972db683947dabed58bb6748257" => :sierra
    sha256 "fdc031ce925717ee49048f3ffab3015f1039a06299f5093f7949e9a41cab975e" => :el_capitan
    sha256 "68247e4d0d0520d9a2615acd906d079951b84e4138b27a69c2aa7ce6a286dd9e" => :yosemite
  end

  depends_on "snappy"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.out").write "test"
    system "#{bin}/snzip", "test.out"
    system "#{bin}/snzip", "-d", "test.out.sz"
  end
end
