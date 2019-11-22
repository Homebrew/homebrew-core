class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "https://laurikari.net/tre/"
  url "https://laurikari.net/tre/tre-0.8.0.tar.bz2"
  sha256 "8dc642c2cde02b2dac6802cdbe2cda201daf79c4ebcbb3ea133915edf1636658"

  bottle do
    cellar :any
    sha256 "26b187538786109c8a08f52cb868ea9cf70dfbc9681c014a4778ead61c90f389" => :catalina
    sha256 "6135ceb88c62b006fb0fbcc772ffd4006da4ae03d05fd872155fa36d33216efc" => :mojave
    sha256 "eaab931989b5bf5fc18949eaa234a1840531ef3aeb9deda65e4d66be40cae149" => :high_sierra
    sha256 "e28b7ac6153b06c067538f555f9ac5973df49c14ac2693aa4239ae407982e2c9" => :sierra
    sha256 "8a1762dbd40b98869e01a19c29cdb1cfa5a127543b3e132fb0fdff996e46f566" => :el_capitan
    sha256 "6fada15a2fd1c5905f8ed45d3c966da5e14efeb10522f82c26d2a23a918abaad" => :yosemite
    sha256 "c57f9bfa724cd20843a672f5e8bd384e05e65bac062dd7d7b676db9b1c11f998" => :mavericks
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "brow", pipe_output("#{bin}/agrep -1 brew", "brow", 0)
  end
end
