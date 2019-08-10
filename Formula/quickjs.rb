class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-08-10.tar.xz"
  sha256 "c6a9c676ead0e84f249f4d27ac6626b4fdb37aa6b4b7c46f94f95071204840fe"

  bottle do
    sha256 "92b69162ea0ae1838e364799cefc06e118761870f016f1e62df9b3e346057c81" => :mojave
    sha256 "1ce5a48ad0423dbc53b09d20bae7c57d2dc8a2eee1a30a709185c05b24a1bd69" => :high_sierra
    sha256 "b843b7a6d945b5295a802ed2e9e0dd5cedfe24947148a428e3f5b5059284f066" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match /^QJS42/, output

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end
