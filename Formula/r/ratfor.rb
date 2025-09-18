class Ratfor < Formula
  desc "Rational Fortran"
  homepage "http://www.dgate.org/ratfor/"
  url "http://www.dgate.org/ratfor/tars/ratfor-1.07.tar.gz"
  sha256 "943b5de328d7b890cb444b17fb7dab656ffaa0d388c7d40b649d34b736b137ff"
  license :public_domain

  livecheck do
    url :homepage
    regex(/href=.*?ratfor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "033c1daa599d6e77dd8072fd53541f5772114d152a028599bd64cc8212217bf7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aed7f3e144962eab6d49fdae060b421362c76899d45716d8e6099488e853f6ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b680bdc4a42beaa254be409281e3ac948edde6feef824945895b44fc5d0ec827"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f96ec748ab19e92ad157a25a6b8a45683d236a090ba19932ca7d653a80c39747"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b700039e4301b9b7e6ae3c9d4e377f0486673c450e63badb8d7c8fd953e5257"
    sha256 cellar: :any_skip_relocation, ventura:       "1bb410b5c28cb156882880dd1fd0c561c303017220a47d5e22183d608419ba19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1015c4ffcb3dc28fb45c5fc2700334b15fa67e1c6dbe133d172401b5d806ea42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f68d0f668b609b9f5aaca3b14983db4f4c3b149eb6d3506a09cabf038b0446"
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

    system bin/"ratfor", "-o", "test.f", testpath/"test.r"
    system "gfortran", "test.f", "-o", "test"
    system "./test"
  end
end
