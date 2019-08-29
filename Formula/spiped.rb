class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.0.tgz"
  sha256 "e6f7f8f912172c3ad55638af8346ae7c4ecaa92aed6d3fb60f2bda4359cba1e4"
  revision 1

  bottle do
    cellar :any
    sha256 "4cf975e7272d99897109b7a5b2cca741d46e9b34d877c6be13a140920d8b8901" => :mojave
    sha256 "f2008c86b377357db0888b384029b54ee9573d73e891ec322018b80dc499d165" => :high_sierra
    sha256 "53e5ec39c188fed1d8a762904988490dd6a73f34f6bfcef986063a34a804cd6a" => :sierra
    sha256 "3597aef864440d96505a2445348060926cbab9b2ea44af4ee61094e4bc419d4e" => :el_capitan
    sha256 "d61db0a6cf96273e9564fcd3208ff5836840b0369e0a9c269c79904d9f1d3ab6" => :yosemite
  end

  depends_on "bsdmake" => :build
  depends_on "openssl@1.1"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
