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
    sha256 "f7088896690bf5d131b89b101f7e6a56dcb927c7be741a92d3041a5943130e5c" => :sierra
    sha256 "8e3b92783684c8e0e2fa55d1dc748579a496b545d4ec53f2b3d4832ac11da95b" => :el_capitan
    sha256 "f8e4dbc74c5261a24df6913d496d002b9a8e597b0fe4a738f42adbb042ef6a80" => :yosemite
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
