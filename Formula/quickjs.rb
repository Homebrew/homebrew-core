class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2021-03-27.tar.xz"
  sha256 "a45bface4c3379538dea8533878d694e289330488ea7028b105f72572fe7fe1a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "29e5de752f621c3c40a18d0616b766fe30a1961d829a975adca2ee1f00e48cc9"
    sha256 big_sur:       "207638559af40db48e5656b490f27aede6882af7dc2cd8721c25d907d54e1fb3"
    sha256 catalina:      "b88f53813926176757beb784b812e17e53522de98e078ae97c385d349a13818c"
    sha256 mojave:        "93f6dc2c5dfd6ac8250b5595a242a5d2892a6a09b4f5999c029ce5bf0e1bb951"
    sha256 high_sierra:   "dfdee7a1285ce8648695c388f8fce766e2113bcd6b11ebd5ba4f21baf988c0fd"
  end

  def install
    system "make", "install", "prefix=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match(/^QJS42/, output)

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end
