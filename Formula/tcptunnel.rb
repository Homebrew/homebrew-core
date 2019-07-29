class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage "http://www.vakuumverpackt.de/tcptunnel/"
  url "https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz"
  sha256 "1926e2636d26570035a5a0292c8d7766c4a9af939881121660df0d0d4513ade4"

  bottle do
    cellar :any_skip_relocation
    sha256 "4084370b62478a4a3bc1943035542dd9b4d452b606ae9bf738bbc4fa53e19fd5" => :mojave
    sha256 "b70d7f63371b5a638fa4d2f0e1cc3f27995f3f20ca1aa1712bb711bb6c9b928c" => :high_sierra
    sha256 "8243b6410ae3d61df3d9c400be33c24b8da0fd0807161a02f38440c18d984661" => :sierra
    sha256 "e387a861c4a9ceb3014883c851cdc43a56eddba635e1d313d976095ff78bb686" => :el_capitan
    sha256 "513995a3f0a331a06ac6531ddad6e1812a9c32add2252852c81d8abe6714c5aa" => :yosemite
    sha256 "d8b4b1fc5969c71bdf24c0793df0d0bcf77475ffd6eeb12a74304d2c6e1c3b1c" => :mavericks
  end

  def install
    bin.mkpath
    system "./configure", "--prefix=#{bin}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/tcptunnel", "--version"
  end
end
