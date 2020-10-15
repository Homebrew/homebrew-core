class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.05.tar.gz"
  sha256 "826278c5cec11f8956984f146e982137e90b0722af5dde9e8c5bf1fef614853c"

  bottle do
    cellar :any_skip_relocation
    sha256 "053917ccdf191b7cb15adb1c207cb3f18553def7d4cc9584b09222be07754660" => :catalina
    sha256 "054cb6d92e13050233c54a5bbfdd1dc9fbaed09d63937b8426d543d9569ee07b" => :mojave
    sha256 "16c83b337e66de93f5e1b21d77242b849a4a1613e2c2e38d1971a77277924bce" => :high_sierra
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
