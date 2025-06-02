class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2025-04-26.tar.xz"
  sha256 "2f20074c25166ef6f781f381c50d57b502cb85d470d639abccebbef7954c83bf"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c95d9c212cf28f7236c7cec3207bb0e60f9366113dd01fb376758ec63e813486"
    sha256 arm64_sonoma:  "50ad44fcd6572ec6eca42f8c8b940d443003dcfac3a79389e64c4ba5b9834660"
    sha256 arm64_ventura: "90f7789068432ae2c08bdb22d541cfcecfe49215448ffc36cbdaaaaf52c3bf6d"
    sha256 sonoma:        "87856de7dd77c5ae0866f3d8b2c1f44c6c6cbd5ceb2b3b2627c0db7a837f800a"
    sha256 ventura:       "b3ddcc47985fd12e9ce6e454ecb5f89a02238c4ead72e41ee7939d958f825cf0"
    sha256 arm64_linux:   "7e005a218d3fc37162d006ad37207f8ffe087d5ffddf8fff3fa3ccf20d660b0a"
    sha256 x86_64_linux:  "c2e635a3d0744604802bf5c7ebbf65c3b74faf1898bd2d37db014d4d858c942b"
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
