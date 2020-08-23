class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-07-05.tar.xz"
  sha256 "63e9f77a4283cede6b37b75dbbe85cb57edc7dd646367650ac2901d9ef268a99"

  bottle do
    sha256 "5bb0910b8bbb4f83a112108a458ac6923db2faa2e4b6e1bf25bbbd0433112802" => :catalina
    sha256 "9c21183602722ad0dd52b1693a71fb983cc6171d841ed4a25f98193ae2e7d5c8" => :mojave
    sha256 "e6152958ae17351bc0dcb13073a34e0c3647f6f1a864ca8f503ca45a68e56576" => :high_sierra
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
