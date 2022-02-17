class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.51.3.tar.gz"
  sha256 "2b0a90c3bf3a27574b0427cf4579dc2347b371bec3fea5739e1527edf74b2809"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?yaze-ag[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "1cc2538b75f03ad957ba2beaeeab1eb84ef8bc6886ada761c589b7ae92d9ee2d"
    sha256 arm64_big_sur:  "96e921633c79477d7354278e9c3706bdae226c00a164843648328638ad32701a"
    sha256 monterey:       "9344c5251b8f30bee15594d429361ddaf99d1373102b899a7d14feca08f2846c"
    sha256 big_sur:        "cd941a70431f2f58c2e69a288154d49b6f426a40e2d457b9edf51ad7941f9aba"
    sha256 catalina:       "294b7e2dbf20ed783e260d0395a4606f095d61debfe5354527ba50a7c4093be6"
    sha256 x86_64_linux:   "365db06c79babcfdf016b422a98c9f778ebc2ab884ff1d741d60aaf140f8980a"
  end

  def install
    if OS.mac?
      inreplace "Makefile_solaris_gcc-x86_64", "md5sum -b", "md5"
      inreplace "Makefile_solaris_gcc-x86_64", /(LIBS\s+=\s+-lrt)/, '#\1'
    end

    bin.mkpath
    system "make", "-f", "Makefile_solaris_gcc-x86_64",
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
