class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", revision: "732"
  version "9.1.22"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256 "25c74ff403edf01eda62cb8b6ce569fd2c5e84319ca5e6189ab6a3109d09ba83" => :big_sur
    sha256 "bfea887cfe99155e28b4700e0eb9b2a7b290a10fa9ee720ab9781c35aa8169bc" => :arm64_big_sur
    sha256 "553aee29312b5b491d20c139652f87d8bd1547abd078285c5c80a13e02a868ff" => :catalina
    sha256 "429ed6272e9255d16227b58bbc405c58d19ecb360540d2d228a91029b62506ab" => :mojave
    sha256 "dfb4e24f378665fee30af8a3c362b1bc13e83b33196b66b4102c400fcee99b2e" => :high_sierra
  end

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
