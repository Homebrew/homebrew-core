class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2026-06-04.tar.xz"
  sha256 "b376e839b322978313d929fd20663b11ba58b75df5a46c126dd19ea2fa70ad2a"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e039fffb364ac044df35683b79969c35b2db9b3b9237664695e71aa11bd63488"
    sha256 arm64_sequoia: "59049d1e7454efb0ece148ac3f40f530dec2598db54a2e7ea6704b371aa5dcdf"
    sha256 arm64_sonoma:  "f81a3997f628bd7397f46476c7e575ae6e6b6bfea219aaaeb28020452ba72c77"
    sha256 sonoma:        "9bbd4f66c4235fd96834d2aa5277be32f2fc9640ac77b182f3ea1b25ee3de7e6"
    sha256 arm64_linux:   "2973056536841451b5d74f1f01788d65ed4f6171e4909a0caa1c582a4094f881"
    sha256 x86_64_linux:  "17a29e2eb7c5f74e6deaf487df1eed9259cfc0f39e46f7ae4289a05192ee99af"
  end

  conflicts_with "quickjs-ng", because: "both install a `qjs` binary"

  def install
    system "make", "install", "PREFIX=#{prefix}", "CONFIG_M32="
  end

  test do
    output = shell_output("#{bin}/qjs --eval 'const js=\"JS\"; console.log(`Q${js}${(7 + 35)}`);'").strip
    assert_match(/^QJS42/, output)

    test_file = testpath/"test.js"
    test_file.write "console.log('hello');"
    system bin/"qjsc", test_file
    assert_equal "hello", shell_output(testpath/"a.out").strip
  end
end
