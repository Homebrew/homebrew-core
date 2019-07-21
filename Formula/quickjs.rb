class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-07-21.tar.xz"
  sha256 "a906bed24c57dc9501b84a5bb4514f7eac58db82b721116ec5abe868490e53cc"

  bottle do
    sha256 "989215f264fc3240904342524457b923da278d6edd53e8fb44dad1f370b4e64f" => :mojave
    sha256 "0f472d5f083df02c3516f42c43333f09fd6e2734da64ce7a4ae027a7e4dc808f" => :high_sierra
    sha256 "3fbf3dfc902c9e68415088325ec7ec6f16e1c69204b3cd3432046d6bed14896e" => :sierra
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
