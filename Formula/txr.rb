class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-232.tar.bz2"
  sha256 "e96b01ce378c21cfbbc69de3c9ff22cd92bc0878c3dfd0356367300154dcab61"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "32b3b2c2aafa5411985cdf4b88040426548ebe8384fef456f9d15060ec2a7da5" => :catalina
    sha256 "23d1c7a895fb436b259795d06ff95248da6c22491c34b815402d65416a21092a" => :mojave
    sha256 "6fb7315405697e68ee47884a93cc6a8ca5175c348b265b468ae8ba01e4d4aaa4" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
