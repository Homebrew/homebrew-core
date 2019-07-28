class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-07-28.tar.xz"
  sha256 "361090ac7d6e30b532b5bf03addfb8017c802a97c15e0843960cef901a10b250"

  bottle do
    sha256 "291f80952057e91b0e8a9bb449bc9e947e81586979fab12ab64144d9619c18d5" => :mojave
    sha256 "f64371e9eaf20c2c0cead535c58019bb0c3c647a01cbbe25d8bb9f392630a1ab" => :high_sierra
    sha256 "a151d816d4799c254fd87ccc8f3576f169bad84298333a98a48d1e429f69a51b" => :sierra
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
