class Spim < Formula
  desc "MIPS32 simulator"
  homepage "http://spimsimulator.sourceforge.net/"
  # No source code tarball exists
  url "http://svn.code.sf.net/p/spimsimulator/code", :revision => 641
  version "9.1.13"

  bottle do
    rebuild 1
    sha256 "aa31b3d73125cc4ad1496a47bcc05ea1db9118348cc44dddfd309e71a70ae3b5" => :sierra
    sha256 "952957b4ebb8b3246378a8c23acde68119659696b781a8e942da63f53a58a982" => :el_capitan
    sha256 "c8664fba396b594ee3fce19490d7e61aa4f1e49b32073289d231309ae168d29c" => :yosemite
    sha256 "008ff237c1a94bcf665a99717ff2ded724cbbdf7585eddc93c8000efab790222" => :mavericks
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
end
