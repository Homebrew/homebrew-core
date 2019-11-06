class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-10-27.tar.xz"
  sha256 "51cdca4eb7851d2eb8b28d442dfaa36213920171a0cf0ebc046802369434a176"

  bottle do
    sha256 "a8e771d888b7e3f540cbff0a9de250a86c591d4979ce0b92aaa0fa861a88eefd" => :catalina
    sha256 "83c8e56fb121b974a608a6364d8805a7b2e5aa685f2ee2e68a3374eb08885945" => :mojave
    sha256 "9447184b11119f128e4a24284a08e2fc6598bd7b49f461025270711b0dfd117a" => :high_sierra
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
