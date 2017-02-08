class Uggconv < Formula
  desc "Universal Game Genie code convertor"
  homepage "http://wyrmcorp.com/software/uggconv/index.shtml"
  url "http://wyrmcorp.com/software/uggconv/uggconv-1.0.tar.gz"
  sha256 "9a215429bc692b38d88d11f38ec40f43713576193558cd8ca6c239541b1dd7b8"

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
