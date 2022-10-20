class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.05.tar.gz"
  sha256 "826278c5cec11f8956984f146e982137e90b0722af5dde9e8c5bf1fef614853c"

  livecheck do
    url :homepage
    regex(/href=.*?ratfor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b7dd12c9a6ec7c9b817cc0f6179dd4b23a517b99a9645818b6dfdf297336ea6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86d1de3e075edcc1e493b46fc7186bd21906644ba69a7032f3bc827487eb9449"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0242f98c14b752d27ed3bf1ce4c92827474918c87e38f541fc95c8cd95a267"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d9bfcd885197bf8bbfbd38469cd831e16f2dceb6cb6155acf075f0dfebcf095"
    sha256 cellar: :any_skip_relocation, catalina:       "053917ccdf191b7cb15adb1c207cb3f18553def7d4cc9584b09222be07754660"
    sha256 cellar: :any_skip_relocation, mojave:         "054cb6d92e13050233c54a5bbfdd1dc9fbaed09d63937b8426d543d9569ee07b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "16c83b337e66de93f5e1b21d77242b849a4a1613e2c2e38d1971a77277924bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc4ca4d1047a943807d656cadc90ed26f141e91435dd60b94a9d4633e729de70"
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
