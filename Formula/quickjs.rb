class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-07-05.tar.xz"
  sha256 "63e9f77a4283cede6b37b75dbbe85cb57edc7dd646367650ac2901d9ef268a99"

  bottle do
    sha256 "05d2f8998a2fd13bb606e0bb74d3eef3a0b80977edf6e543b98fd0320715733d" => :catalina
    sha256 "4c7dc36152c0a7d04ab3be8ef7f22c91332816dada0a1c66ad87df3537237dd7" => :mojave
    sha256 "49747bbada54cb4b97c218a5fbc202247a0820e5c7f6f9ccaf7001b7581a3fdc" => :high_sierra
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
