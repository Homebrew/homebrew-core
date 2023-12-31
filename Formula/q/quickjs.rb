class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2023-12-09.tar.xz"
  sha256 "e8afe386f875d0e52310ea91aa48e2b0e04182e821f19147794e3e272f4c8d8c"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "ffe454f6a6769362ec1815202bd8334fa7e5ed16b508bcf156c803fde955b26c"
    sha256 arm64_ventura:  "a6225bcd309365375cbe089ab244c7dea6380472371aed81d46980b12b5a1296"
    sha256 arm64_monterey: "c0ce5f4db7bc80887e48848927c6494017c70dd4a93d98190c273a21f8708150"
    sha256 sonoma:         "cae8f5c7521a1384e3b0d56fc9f1ee938e5873028725ca8cda26923218b9cc32"
    sha256 ventura:        "e600e961deea4c58270b4781e17e7f965e39fb90320747e336a761dd5f0f46a9"
    sha256 monterey:       "6f2f33cd8834d693faea27f674c040f4cd4784b6eced7fbe921e97171d293f40"
    sha256 x86_64_linux:   "7e80912dedcc5230d9cf0d6af6ca8f0d9a53c4c533ca249cfa35776fa6c91660"
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
