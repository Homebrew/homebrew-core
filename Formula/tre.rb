class Tre < Formula
  desc "Lightweight, POSIX-compliant regular expression (regex) library"
  homepage "https://laurikari.net/tre/"
  url "https://laurikari.net/tre/tre-0.8.0.tar.bz2"
  sha256 "8dc642c2cde02b2dac6802cdbe2cda201daf79c4ebcbb3ea133915edf1636658"

  bottle do
    sha256 cellar: :any, arm64_monterey: "eed6c3c934fdeb27988331fe31137cd3849a46c877ff05e614f544e140ff9ab8"
    sha256 cellar: :any, arm64_big_sur:  "70e4b1149b1e72f6f86634dca2814241bddc8b5239cc243dd27ff7cfe669680e"
    sha256 cellar: :any, monterey:       "f2f8c94e26b27a1e3e1dcc8d99fa375ade859cc85ee1b53a7a02c8f79137f721"
    sha256 cellar: :any, big_sur:        "112a8c8590e654fbbbd5339cf5b3fa83a5c163c3320fcb386ddc0affad7148b2"
    sha256 cellar: :any, catalina:       "26b187538786109c8a08f52cb868ea9cf70dfbc9681c014a4778ead61c90f389"
    sha256 cellar: :any, mojave:         "6135ceb88c62b006fb0fbcc772ffd4006da4ae03d05fd872155fa36d33216efc"
    sha256 cellar: :any, high_sierra:    "eaab931989b5bf5fc18949eaa234a1840531ef3aeb9deda65e4d66be40cae149"
    sha256 cellar: :any, sierra:         "e28b7ac6153b06c067538f555f9ac5973df49c14ac2693aa4239ae407982e2c9"
    sha256 cellar: :any, el_capitan:     "8a1762dbd40b98869e01a19c29cdb1cfa5a127543b3e132fb0fdff996e46f566"
    sha256 cellar: :any, yosemite:       "6fada15a2fd1c5905f8ed45d3c966da5e14efeb10522f82c26d2a23a918abaad"
    sha256               x86_64_linux:   "1b8c9e6644e085500532d787b850f351032b8bb1f583dca9397d533c27e75a9b"
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
