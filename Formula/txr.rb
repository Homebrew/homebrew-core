class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-236.tar.bz2"
  sha256 "293c0f02b7553001392789cff5da727b1ca085f2a05fd5d3fda1f88b72a3b031"
  license "BSD-2-Clause"

  disable!

  bottle do
    cellar :any_skip_relocation
    sha256 "2fb63dd53592222c6052cbf181e8fc76b0bd3b628b69d53b603240d265db320e" => :catalina
    sha256 "1495de462a044f69966d14cb897fbd2e77089c70812e97986db536089c4376e5" => :mojave
    sha256 "de2258c0669930f71c946e0875d4072fb9b5a50a17803f6c85671b5027db2717" => :high_sierra
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
