class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2020-01-05.tar.xz"
  sha256 "76642c98c9c3c3d3fee3321689ea8bfc9ab94a8bb4759aefa2749f832f52d36d"

  bottle do
    sha256 "f42c786f0081402e0f3c5825fb2404751217a2c06652a651e1dbb4ef0551739e" => :catalina
    sha256 "5746e7930bb9d47789fe36ba44be9e82623cf1ce856ca793cf705271fb1ae4c3" => :mojave
    sha256 "8295d3d4e5ff008eef2f98e5033fb13375c6e77803fd93b025940ac61bf82212" => :high_sierra
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
