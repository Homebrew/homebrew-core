class Txr < Formula
  desc "Original, new programming language for convenient data munging"
  homepage "https://www.nongnu.org/txr/"
  url "http://www.kylheku.com/cgit/txr/snapshot/txr-192.tar.bz2"
  sha256 "5661b05c0dd672f6ab1ffbe19c93005a4980a3af42a66ba3122eb54179708728"
  head "http://www.kylheku.com/git/txr", :using => :git

  bottle do
    cellar :any_skip_relocation
    sha256 "a01d82f2ffcc27f7693b7d34d02f14778b43219413fb886c85c4265b8d157360" => :high_sierra
    sha256 "b94edf2853514e910f9b7be7e2ee2cab296caafbac159ef4011607261bfcddea" => :sierra
    sha256 "026c5650def52db7ffa489403fde0017773b7add3701bf1996e921c7d100d86e" => :el_capitan
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "3", shell_output(bin/"txr -p '(+ 1 2)'").chomp
  end
end
