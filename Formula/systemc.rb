class Systemc < Formula
  desc "Core SystemC language and examples"
  homepage "https://accellera.org/"
  url "https://accellera.org/images/downloads/standards/systemc/systemc-2.3.3.zip"
  sha256 "fcdce4395a7d862fc891b4da9ced69c4a58f8670b56fafca0004cf4e72fdf7a1"

  bottle do
    cellar :any
    sha256 "ed266b79f596258da162637530a1830516ceee6fb4874add5eaa9a84b175cda4" => :mojave
    sha256 "7d189564e4277390f8fa0c2e067f17dc31148e33af65c0998b6242405f761a18" => :high_sierra
    sha256 "257ab0155a4e4f5d6dea22696f265d1a523efa24627487a5fad4ad70d43e7fd0" => :sierra
    sha256 "8dbfcaef7cbca7116bacb300288520ed357768c148a612de2f9a3483266add87" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-arch-suffix=",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "systemc.h"

      int sc_main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cxx, "-L#{lib}", "-lsystemc", "test.cpp"
    system "./a.out"
  end
end
