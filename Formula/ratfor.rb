class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.04.tar.gz"
  sha256 "c1d99c1a9e17693a4f605c20a1bb27adc9d1616e95eb7c104ec1fe2d8b96da6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "6710039b41c9561502656c7982a05979deb0540610497486d5d91110551298a1" => :catalina
    sha256 "f4e9c020af7fe076ed992246fb4ed12cc57792072a4663d26dabe3b911ed51ed" => :mojave
    sha256 "289e404734d337b687b6d1042ac3ca693c2b8e6a10393b5e84c2170f79f1d39b" => :high_sierra
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.r").write <<~EOS
      integer x,y
      x=1; y=2
      if(x == y)
              write(6,600)
      else if(x > y)
              write(6,601)
      else
              write(6,602)
      x=1
      while(x < 10){
        if(y != 2) break
        if(y != 2) next
        write(6,603)x
        x=x+1
        }
      repeat
        x=x-1
      until(x == 0)
      for(x=0; x < 10; x=x+1)
              write(6,604)x
      600 format('Wrong, x != y')
      601 format('Also wrong, x < y')
      602 format('Ok!')
      603 format('x = ',i2)
      604 format('x = ',i2)
      end
    EOS

    system "#{bin}/ratfor", "-o", "test.f", testpath/"test.r"
    system "gfortran", "test.f", "-o", "test"
    system "./test"
  end
end
