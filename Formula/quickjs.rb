class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-09-18.tar.xz"
  sha256 "ae4395d3f45045f920069e6c203ddb3fc3e549ce8fa3c429e696880cff010575"

  bottle do
    sha256 "c54904d3ef1234828336a25974be158e9749912a53b1fb5bb18f6d6313d0ae0b" => :catalina
    sha256 "a069333872b286a1b581c8149c79bf108c53c7497aed8593a4f04016ecc9291c" => :mojave
    sha256 "395d76691e37c5103a33ea9e028eb46bc15c8b0a1ed7f9dcfecbb65d32ce7003" => :high_sierra
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
