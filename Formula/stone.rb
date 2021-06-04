class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "https://www.gcd.org/sengoku/stone/"
  url "https://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz"
  sha256 "b2b664ee6771847672e078e7870e56b886be70d9ff3d7b20d0b3d26ee950c670"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a91a4ebc8ed1aaa5ad7095fb0098ea3bedec1c1df5628c817bb3e056be206ca1"
    sha256 cellar: :any_skip_relocation, big_sur:       "eb18046ea36b9f45dd8f67958dab8030a0ac8056b041a7f6936328d357f3a045"
    sha256 cellar: :any_skip_relocation, catalina:      "8b37777addb031114cadd5d09ca216ffaff9df2316073077c79c072d9debc761"
    sha256 cellar: :any_skip_relocation, mojave:        "0d2db17e57c53f2be5b1b8feea072923bddd3c86efe37c9a8db6296087ee5687"
    sha256 cellar: :any_skip_relocation, high_sierra:   "579a9dee4b6fb57f0f1313a656250b00a428bdff7c2401431bb96d0ef0496c25"
    sha256 cellar: :any_skip_relocation, sierra:        "540bd64b2264bfe03d88ad620a7138a1d96742d6810eec301fd7e5ea63970ee9"
    sha256 cellar: :any_skip_relocation, el_capitan:    "9d4038c7882d2fe256d77340b5e0ec52a551697b9869fb61f3a22b0be917e92b"
    sha256 cellar: :any_skip_relocation, yosemite:      "e01e391d43da23b477186a54f96b0d20bb67c24e1503e20408dc12d025f04def"
  end

  def install
    system "make", "macosx"
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end
