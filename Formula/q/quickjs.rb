class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2025-09-13-2.tar.xz"
  version "2025-09-13-2"
  sha256 "996c6b5018fc955ad4d06426d0e9cb713685a00c825aa5c0418bd53f7df8b0b4"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "0c4a5557adceba07641b2d0df1a7dc4a80a95cb8d95cb8e89a75deabd2cac755"
    sha256 arm64_sequoia: "6b8a9c3c838646ff828233f6ed5af58974985f076ab68a9b4337da8d0e01411a"
    sha256 arm64_sonoma:  "6ac5d8f62afabf4912fb5173a417c08f9118f3ed0fd88c069ee91d74d6a08c1b"
    sha256 sonoma:        "a2ce1cdd3b921b02c123850b83ff78d4d983fc487c04bfdf93352d415bf6f253"
    sha256 arm64_linux:   "4a3b2817c7f28db585ece2b4e317fe6ce0079a6c716dd2ef9e612a80d7106089"
    sha256 x86_64_linux:  "547f293bb0c5b1de7fe993352bc26192627f16a36128d64bb9b9dbd9b2afca2e"
  end

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
