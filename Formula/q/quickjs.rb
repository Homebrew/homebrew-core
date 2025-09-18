class Quickjs < Formula
  desc "Small and embeddable JavaScript engine"
  homepage "https://bellard.org/quickjs/"
  url "https://bellard.org/quickjs/quickjs-2025-09-13.tar.xz"
  sha256 "6f1f322aea3bb3a90858db85c9fe717013fde4df7dfcafe2f57e78f5bb4b4a0c"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?quickjs[._-]v?(\d+(?:[.-]\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "e828a899d98c6f7e8a1b355f9b48982f328862fd61b4b0635413da7f6aff585d"
    sha256 arm64_sequoia: "0ae282e76a2e7c3c4e0ebabb4835a436870cb9d8951dcc54c919d1eb8b7c75e7"
    sha256 arm64_sonoma:  "dff370175b666cfa4b524c491c55d2608ffa72b1503cf95bb341717d5ff0091c"
    sha256 sonoma:        "c88ad1eb2a750556ef61d161033e24bb17232283670e22c4cc2b272b7f03d451"
    sha256 arm64_linux:   "5e03e1662d6892aa1ac8155bbb1c942da7d83c725cd1fb62cc3a8ca8c4003bdc"
    sha256 x86_64_linux:  "00a5cc4f79e5c907f77229d8d18cb925fbdc179b1a7a922fdd02801048d04a49"
  end

  def install
    # Create dummy JSON file in `examples` path
    # so that `make install` does not return an error
    # https://github.com/bellard/quickjs/issues/440
    (buildpath/"examples/message.json").write "{}"
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
