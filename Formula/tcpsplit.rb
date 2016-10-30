class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "http://www.icir.org/mallman/software/tcpsplit/"
  url "http://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz"
  sha256 "885a6609d04eb35f31f1c6f06a0b9afd88776d85dec0caa33a86cef3f3c09d1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "2e9d12ee609d30075f141527c3804ce78a8c312e5b72ce6eb655ed08521faf45" => :sierra
    sha256 "5014edcbc87913b2103c9347dd4b132ca1b4c3b1a007c853eda75213481e7d30" => :el_capitan
    sha256 "c87bf331cb20c6301b922ee3fb37f0c92957f3e32d0391b07aa7b36980b20819" => :yosemite
    sha256 "ec4011f01c1d8c2f71172956b70b99336aa8ec89372d37c1678caa23d6986f1a" => :mavericks
  end

  def install
    system "make"
    bin.install "tcpsplit"
  end
end
