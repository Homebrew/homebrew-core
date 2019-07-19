class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2019-07-09.tar.xz"
  sha256 "350c1cd9dd318ad75e15c9991121c80b85c2ef873716a8900f811554017cd564"

  bottle do
    sha256 "989215f264fc3240904342524457b923da278d6edd53e8fb44dad1f370b4e64f" => :mojave
    sha256 "0f472d5f083df02c3516f42c43333f09fd6e2734da64ce7a4ae027a7e4dc808f" => :high_sierra
    sha256 "3fbf3dfc902c9e68415088325ec7ec6f16e1c69204b3cd3432046d6bed14896e" => :sierra
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/qjs -e 'console.log(\"hello\");'").strip
    assert_equal "hello", output

    path = testpath/"test.js"
    path.write "console.log('hello');"
    system "#{bin}/qjsc", path
    output = shell_output(testpath/"a.out").strip
    assert_equal "hello", output
  end
end
