class Uggconv < Formula
  desc "Universal Game Genie code convertor"
  homepage "https://wyrmcorp.com/software/uggconv/index.shtml"
  url "https://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"

  bottle do
    cellar :any_skip_relocation
    sha256 "71b4a6ad5be4b5dbefe2c64dc17b6bcff00eedcf72070f4a22273ff1f0a392cd" => :mojave
    sha256 "ed41635e3235d763c9dcad68db2e390821af5a62ec6709fca8b9c5e9b5d0b995" => :high_sierra
    sha256 "a22594f94bf7baa1908bd1225f52f1db3dd01daa17f99038ecfbd60e22d12b5d" => :sierra
    sha256 "5ab8b271f2ccc17e5229921f01b92ff7b0c297908902c83d24612bb47592af3c" => :el_capitan
    sha256 "a40a8a1adee9286acedba6e8eedf20bc53e4bf291fc73478bd3ba0314792c6ce" => :yosemite
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
