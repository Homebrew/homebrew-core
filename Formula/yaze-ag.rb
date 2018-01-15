class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.40.5_with_keytrans.tar.gz"
  version "2.40.5"
  sha256 "d46c861eb0725b87dd5567062f277860b98d538fca477d8686f17b36ef39d9bd"

  bottle do
    sha256 "5a7cb2f9fe6c900a557786f8026c47a75272bf71bc74f1fbedf2c2648c17db0c" => :high_sierra
    sha256 "bee2b2a896191528e71c1d986ecf4ca2fb3923f27617715542137d618584ea55" => :sierra
    sha256 "97ffe6edc70a797cbb26d9399f49b46570b80b705a5d52a0b4fded357bc317ed" => :el_capitan
  end

  def install
    inreplace "Makefile_solaris_gcc", "md5sum -b", "md5"
    bin.mkpath
    system "make", "-f", "Makefile_solaris_gcc",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    (testpath/"cpm").mkpath
    assert_match "yazerc", shell_output("#{bin}/yaze -v", 1)
  end
end
