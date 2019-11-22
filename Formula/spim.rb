class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 712
  version "9.1.20"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256 "e4251f5e6241a4f468e7ba4d366e1a3271946e0716ec6440893908eeb12d236d" => :catalina
    sha256 "3d72a5493c97fc542e714595358efdfbbc58a2e84cbaef8ca449b7a943c00302" => :mojave
    sha256 "cde6c0f680acb27b47a9eca2279e72c245360322d5ee910ebc01bb24140285a9" => :high_sierra
    sha256 "29ac5a63bd12dd986b578a31ea0d1a6029940551084c3273d572c68b93f68f38" => :sierra
  end

  def install
    bin.mkpath
    cd "spim" do
      system "make", "EXCEPTION_DIR=#{share}"
      system "make", "test"
      system "make", "install", "BIN_DIR=#{bin}",
                                "EXCEPTION_DIR=#{share}",
                                "MAN_DIR=#{man1}"
    end
  end

  test do
    assert_match "__start", pipe_output("#{bin}/spim", "print_symbols")
  end
end
