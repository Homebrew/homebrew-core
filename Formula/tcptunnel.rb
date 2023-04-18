class Tcptunnel < Formula
  desc "TCP port forwarder"
  homepage "http://www.vakuumverpackt.de/tcptunnel/"
  url "https://github.com/vakuum/tcptunnel/archive/v0.8.tar.gz"
  sha256 "1926e2636d26570035a5a0292c8d7766c4a9af939881121660df0d0d4513ade4"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9503c7ec45671862d4d806931e056c9d0c6e7ea9cdda143bd17ea355b6c6a78a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08ea4f67e68abd0d281d62a9f59f172b3ada2f84de3efba2c66318909686fd04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f551ae0b42199f7636702669a5f32d4fb6bafef330036e8b14f3cfda556a4d32"
    sha256 cellar: :any_skip_relocation, ventura:        "8eb0261ee4669e199766ea61e9b9f7ab7cd1b9ca51794f5d26650c542dc55e10"
    sha256 cellar: :any_skip_relocation, monterey:       "d75d983ef25fb64ae2d4fef51dd7c5a29451a3326ae99f2aaf24254d174d9f3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "65ab13dc5646735a64d821e3eab7f04a55bd0739b83b36769b3d0664de74ed80"
    sha256 cellar: :any_skip_relocation, catalina:       "e82c25ab68b43d632739d345b3ac1c3a6d22a9c8a51d44f9cfc3967e64469794"
    sha256 cellar: :any_skip_relocation, mojave:         "4084370b62478a4a3bc1943035542dd9b4d452b606ae9bf738bbc4fa53e19fd5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b70d7f63371b5a638fa4d2f0e1cc3f27995f3f20ca1aa1712bb711bb6c9b928c"
    sha256 cellar: :any_skip_relocation, sierra:         "8243b6410ae3d61df3d9c400be33c24b8da0fd0807161a02f38440c18d984661"
    sha256 cellar: :any_skip_relocation, el_capitan:     "e387a861c4a9ceb3014883c851cdc43a56eddba635e1d313d976095ff78bb686"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b82ce2df1293960dc7d0e4b5b9d809198073121331d7287edacbd5cffe17d94c"
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
