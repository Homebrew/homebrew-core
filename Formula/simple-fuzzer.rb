class SimpleFuzzer < Formula
  desc "Simple Fuzzer"
  homepage "http://aaron.bytheb.org/programs/sfuzz.html"
  url "https://github.com/orgcandman/Simple-Fuzzer.git",
      :commit => "3bf135bf1dfab5ddffb40f273a37d6502d95b752"
  version "0.7.1"
  head "https://github.com/orgcandman/Simple-Fuzzer.git"

  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "sfuzz"
  end

  test do
    system "#{bin}/sfuzz", "-h"
  end
end
