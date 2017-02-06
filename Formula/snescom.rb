class Snescom < Formula
  desc "Compile 65816/65c816 machine code"
  homepage "http://bisqwit.iki.fi/source/snescom.html"
  url "http://bisqwit.iki.fi/src/arch/snescom-1.7.4.1.tar.bz2"
  sha256 "e80187d969fd448fe4d3c636bdbe9c24fe452e1436566b29fbf3410bde739504"

  bottle do
    cellar :any
    sha256 "102cfb6d03ac2dede67119f47329a1db8436f001946ef36c285b7bb3463dafa3" => :yosemite
    sha256 "2ef1408312be3110c88e5be2f9e7b736a8d498ade8335b5076da09585ebff971" => :mavericks
    sha256 "23af80922e45a7937086900f06e213fb017b6afdde06b3ab96db2ce7b7f784ce" => :mountain_lion
  end

  patch :p1 do
    # Includes cstdlib for Clang.
    # Reported upstream, should be fixed in the next release.
    url "https://gist.githubusercontent.com/protomouse/31335db2fe5c11978faf/raw/f0671999314e87c0487035e4f80f92a67a0c4d06/snescom-disasm-missing-cstdlib.diff"
    sha256 "3e214ae0a5751dfe72f81c0723b792601ddb4bca335dd2d5fd345572f051e29c"
  end

  depends_on "boost" => :build

  def install
    system "make"

    bin.install "disasm", "snescom", "sneslink"
    doc.install "README.html"
  end

  test do
    (testpath/"test.a65").write <<-EOS.undent
      GAME_MAIN:
        rts
    EOS
    system "#{bin}/snescom", "-Wall", "-fips", "-o", "test.ips", "test.a65"
    asm = `#{bin}/disasm test.ips`
    assert_match(/.extern GAME_MAIN/, asm)
  end
end
