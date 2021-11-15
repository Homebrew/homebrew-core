class Uggconv < Formula
  desc "Universal Game Genie code converter"
  homepage "https://wyrmcorp.com/software/uggconv/index.shtml"
  url "https://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"

  # The homepage gives the status as "Final (will not be updated)" and it was
  # last modified on 2001-12-12.
  livecheck do
    skip "No longer developed"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "002cd504e9385234ab9b1b4595709ffccb2fda5d49c377add9c27eb422c04ed3"
    sha256 cellar: :any_skip_relocation, big_sur:       "820cca76f8c5618ba401a343644cffae2ece5526e0295dc29d0dd0f5f524789a"
    sha256 cellar: :any_skip_relocation, catalina:      "c1fc237ad27120a1804b37d765a47833d67bcd38cfa67be07aed808739021146"
    sha256 cellar: :any_skip_relocation, mojave:        "71b4a6ad5be4b5dbefe2c64dc17b6bcff00eedcf72070f4a22273ff1f0a392cd"
    sha256 cellar: :any_skip_relocation, high_sierra:   "ed41635e3235d763c9dcad68db2e390821af5a62ec6709fca8b9c5e9b5d0b995"
    sha256 cellar: :any_skip_relocation, sierra:        "a22594f94bf7baa1908bd1225f52f1db3dd01daa17f99038ecfbd60e22d12b5d"
    sha256 cellar: :any_skip_relocation, el_capitan:    "5ab8b271f2ccc17e5229921f01b92ff7b0c297908902c83d24612bb47592af3c"
    sha256 cellar: :any_skip_relocation, yosemite:      "a40a8a1adee9286acedba6e8eedf20bc53e4bf291fc73478bd3ba0314792c6ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70d91fd685adcb8943530056934bc1e8f0ed0c5502a9205c6b1c8fa982fdec53"
  end

  def install
    system "make"
    bin.install "uggconv"
    man1.install "uggconv.1"
  end

  test do
    assert_equal "7E00CE:03    = D7DA-FE86\n",
      shell_output("#{bin}/uggconv -s 7E00CE:03")
  end
end
