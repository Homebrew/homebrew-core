class Unp64 < Formula
  desc "Generic C64 prg unpacker,"
  homepage "http://iancoog.altervista.org/"
  url "http://iancoog.altervista.org/C/unp64_234.7z"
  version "2.34"
  sha256 "86968afaa13b6c17fac7577041d5e3f3cc51cb534d818b5f360fddf41a05eaad"

  def install
    system "make", "-C", "unp64_234/src", "unp64"
    bin.install "unp64_234/src/Release/unp64"
  end

  test do
    code = [0x00, 0xc0, 0x4c, 0xe2, 0xfc]
    File.open(testpath/"a.prg", "wb") do |output|
      output.write [code.join].pack("H*")
    end

    output = shell_output("#{bin}/unp64 -i a.prg 2>&1")
    assert_match "a.prg :  (Unknown)", output
  end
end
