class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "https://www.icir.org/mallman/software/tcpsplit/"
  url "https://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz"
  sha256 "885a6609d04eb35f31f1c6f06a0b9afd88776d85dec0caa33a86cef3f3c09d1d"

  livecheck do
    url :homepage
    regex(/href=.*?tcpsplit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf4362d064b7f982e0fb8cb2e79010c80c19f555b79f18dd0e4f3a9dbfda8a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f40f957faef51ed496030a97cda8ca0eb0716826969872185080bb8e94780f36"
    sha256 cellar: :any_skip_relocation, monterey:       "51e4f267ddd4cd76011a85b0e094d78d4df67b4a3d16d6dd918834a929cba203"
    sha256 cellar: :any_skip_relocation, big_sur:        "49781c99d1496c5c0c8ec3e56e2edc604f5e8643f36e93b0ff8b974d448363d1"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3131cd8829f943cc4142dc616adfa696ff9d0af5dc21f94408d114f59434cd"
    sha256 cellar: :any_skip_relocation, mojave:         "b3a7f083a50a33edf1799fc16b6d52db71eee85bd69bad9d1d3d42e6de5cfa6f"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0b603f1737a000ec2452bd3ac48df7c4e04d6cfb15fc48dabca96bd23137f40a"
    sha256 cellar: :any_skip_relocation, sierra:         "2e9d12ee609d30075f141527c3804ce78a8c312e5b72ce6eb655ed08521faf45"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5014edcbc87913b2103c9347dd4b132ca1b4c3b1a007c853eda75213481e7d30"
    sha256 cellar: :any_skip_relocation, yosemite:       "c87bf331cb20c6301b922ee3fb37f0c92957f3e32d0391b07aa7b36980b20819"
  end

  def install
    system "make"
    bin.install "tcpsplit"
  end

  test do
    system "#{bin}/tcpsplit", "--version"
  end
end
