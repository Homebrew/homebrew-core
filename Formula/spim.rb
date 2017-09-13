class Spim < Formula
  desc "MIPS32 simulator"
  homepage "https://spimsimulator.sourceforge.io/"
  # No source code tarball exists
  if MacOS.version >= :sierra
    url "https://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  else
    url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 707
  end
  version "9.1.19"
  head "https://svn.code.sf.net/p/spimsimulator/code/"

  bottle do
    sha256 "8a3717f7373bd8b9f4a85b335c321b27597dcd64ee22fc05921e96241458a191" => :sierra
    sha256 "0b2c254bc2ab638516345e0fe44b29859179c6ec62704fb369e485a645178bbd" => :el_capitan
    sha256 "1207f278f326747acbb97e272724d72dd467e90b4ef798365206958ccd54957a" => :yosemite
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
