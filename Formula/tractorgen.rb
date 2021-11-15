class Tractorgen < Formula
  desc "Generates ASCII tractor art"
  homepage "http://www.vergenet.net/~conrad/software/tractorgen/"
  url "http://www.vergenet.net/~conrad/software/tractorgen/dl/tractorgen-0.31.7.tar.gz"
  sha256 "469917e1462c8c3585a328d035ac9f00515725301a682ada1edb3d72a5995a8f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?tractorgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1049100b1891c7793e614bd2664b64e44ea4530d747bd045c2cff706b590d293"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc7c0c6f2a31533393973e0931d984d1ceff57e2ee1f49c03a8633d33ecfde7b"
    sha256 cellar: :any_skip_relocation, monterey:       "2b4816dae0957cd762efafda336d1a34c7b45feca63e366bf53c4267dbbb47c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "15391ab31cdfcf2c6a844b9e39aed0fabb01e0aa3d03e7a72602f02f0f0e759c"
    sha256 cellar: :any_skip_relocation, catalina:       "b28ff1c764b92992d82e16d8ab283215101f3a3aeabcf9aa2d4a952451a779dc"
    sha256 cellar: :any_skip_relocation, mojave:         "0416b04f09a509f3912de4cac964fb96e2a54246f8ffb9d170d4f2bb16b6f959"
    sha256 cellar: :any_skip_relocation, high_sierra:    "936883746158534e9650a0b26f18e680eed527fb56f71ad51e5ec203d8f7f451"
    sha256 cellar: :any_skip_relocation, sierra:         "646d87ca0cb1a5ec93a8aa1ddaa1f28233347ca0a1f56e49c323809ec8295432"
    sha256 cellar: :any_skip_relocation, el_capitan:     "ccac503b4577fc81e69d3e778c27c31fad9a1c5fa8627e97f293d87ab1177f8d"
    sha256 cellar: :any_skip_relocation, yosemite:       "e50de2fd2d9015873282a62fc7a21f3ef419d527d07eeab3830ace52ec25c3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d67a731185350d21bdeea6e2e6a478409b430f371d21f6b595d44e7b7ebc2363"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    expected = <<~'EOS'.gsub(/^/, "     ") # needs to be indented five spaces
          r-
         _|
        / |_\_    \\
       |    |o|----\\
       |_______\_--_\\
      (O)_O_O_(O)    \\
    EOS
    assert_equal expected, shell_output("#{bin}/tractorgen 4")
  end
end
