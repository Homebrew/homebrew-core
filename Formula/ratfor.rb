class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.04.tar.gz"
  sha256 "c1d99c1a9e17693a4f605c20a1bb27adc9d1616e95eb7c104ec1fe2d8b96da6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "e98f4edddd16530a9fed1092cac305336a8c3ef46389c8208278c3ff2337b4b7" => :catalina
    sha256 "1778a37f2498200cef410a1b208d1f21f591f909f13b566b139bb66f70734f88" => :mojave
    sha256 "4a9b3b69f2eadb0023747734a5b1145717d3d776742eb555c35ae20edd0e5d59" => :high_sierra
    sha256 "ab06a92daf0033b37df76b0a8f8b0191718017d1b7c629c1af82eca0117c8da2" => :sierra
    sha256 "f6556cca206a70a3dca1ac897078cdbbe61be5c3b2c5e70e540b11998f8f0f5e" => :el_capitan
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
