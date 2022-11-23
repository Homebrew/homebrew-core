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
    sha256 arm64_ventura:  "be1ba0dc988a714a4b33a5d1dbf028b5c0438c6a07854db4b076ca4e54c12c16"
    sha256 arm64_monterey: "e9f1c2d64092a5b0084e3ad49c9f7936efbc48d54ffbcf423cfa900cf62616eb"
    sha256 arm64_big_sur:  "c6fe0bfcc35db87914873424e1a7d4386362eeb008ef1fb28e78cd87811bbb14"
    sha256 ventura:        "170832cb5130c215c1598393faf7ac8ca238034f03e3bf2593415837ffcce76e"
    sha256 monterey:       "bfbc5d750e690dc1d65a818ba6b5fc3eaa86fcd0110ab1cd6ba51c82bb356a0b"
    sha256 big_sur:        "fe0f2ea5d5afcdf52bd8fc70277f27b39e00aeda8229bcb2d59d01a8454704ca"
    sha256 catalina:       "ec26dd8206150e0f19102256a47a77c4373b61ba9a91981050a6fa000f010284"
    sha256 mojave:         "de7929242e69797033d62921e1605c67890e5dbe13f05cd09e01724962d12624"
    sha256 x86_64_linux:   "8c6aaa6a5226d20c18da497df09507dc06ce352047e18e7202bc4275cfbeb908"
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
