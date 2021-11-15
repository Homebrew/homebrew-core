class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", revision: "732"
  version "9.1.22"
  license "BSD-3-Clause"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256                               arm64_monterey: "ed739824d1bfdc0d03c8d7c5ce9d6b830c03a0bd45df0c36edfc94eebed1d463"
    sha256                               arm64_big_sur:  "bfea887cfe99155e28b4700e0eb9b2a7b290a10fa9ee720ab9781c35aa8169bc"
    sha256 cellar: :any_skip_relocation, monterey:       "4fda2fdc2f6c359ed20570456dd0139b5d4fc251c677fd809dd6a5711c5e7005"
    sha256                               big_sur:        "25c74ff403edf01eda62cb8b6ce569fd2c5e84319ca5e6189ab6a3109d09ba83"
    sha256                               catalina:       "553aee29312b5b491d20c139652f87d8bd1547abd078285c5c80a13e02a868ff"
    sha256                               mojave:         "429ed6272e9255d16227b58bbc405c58d19ecb360540d2d228a91029b62506ab"
    sha256                               high_sierra:    "dfb4e24f378665fee30af8a3c362b1bc13e83b33196b66b4102c400fcee99b2e"
    sha256                               x86_64_linux:   "deaec14a9d199bef4831d6301a295c0c1598417ddd99ff1641c60a045827998a"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

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
