class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.03.tar.gz"
  sha256 "d77497cd0856aad43e0d122f04aef4965994b744f1af9ab1237d7cd6849d139c"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3fce149ad7259cf7bf2873d92434bf4882c065fd4f29e21f9bc5d19470879fd" => :high_sierra
    sha256 "fe4b59768af9db9e323ce5419e8387ffdd29b45e89f2651340a45e037ebf2336" => :sierra
    sha256 "93d6bbe2c8b41e06adaadd365672c651f2fa1942aa283875bc1e54f8cec34fb3" => :el_capitan
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "check"
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
    ENV.fortran
    system ENV.fc, "test.f", "-o", "test"
    system "./test"
  end
end
