class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.03.tar.gz"
  sha256 "d77497cd0856aad43e0d122f04aef4965994b744f1af9ab1237d7cd6849d139c"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e26348fdb8d1f44321bcb7cef4f69c48c9d16cad5fec96b421b9fd1030bf1529" => :high_sierra
    sha256 "46728e56e09c117379d3d588eafe15aa9f7ecd18055e3d7ae34d437b130bde30" => :sierra
    sha256 "78444ca50e14d07eb52c827c9760f706acf4745d467fae4d2e05953a7c921b95" => :el_capitan
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
