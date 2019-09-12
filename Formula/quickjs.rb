class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-09-01.tar.xz"
  sha256 "99c74283aadc505d288845b2e40b2c1b2d35460786859017090c124f4fde9945"

  bottle do
    sha256 "eaa671e1f694b764ac1f99c60cbbcc884c5d731002bfc02354de2d815a65789b" => :mojave
    sha256 "5cbd7324e870cba1ce4430771a293c27a1ddfa8398ea086a33a8c670490da866" => :high_sierra
    sha256 "cc06fc61838d40ee13af262f8979821e1c72a85a950510755b587108dc98a863" => :sierra
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
