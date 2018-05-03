class Unp64 < Formula
  desc "Generic C64 prg unpacker,"
  homepage "http://iancoog.altervista.org/"
  url "http://iancoog.altervista.org/C/unp64_234.7z"
  version "2.34"
  sha256 "86968afaa13b6c17fac7577041d5e3f3cc51cb534d818b5f360fddf41a05eaad"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb2f615c3909bbf88db626681db7b07c22f94c72bb51a9dbb9ddc8b37c117202" => :high_sierra
    sha256 "f5ad308ae7daacc0419de6e9f131f78431b07a63a882078c7deded097065d4ff" => :sierra
    sha256 "730e5e71632110da2e1220001c63b86e29a302cb2ed2762f988625f4afa9722f" => :el_capitan
  end

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
