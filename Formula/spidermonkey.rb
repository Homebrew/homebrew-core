class Spidermonkey < Formula
  desc "Mozilla's JavaScript engine, as used in Firefox"
  homepage "https://developer.mozilla.org/en/SpiderMonkey"
  url "https://archive.mozilla.org/pub/firefox/tinderbox-builds/mozilla-release-macosx64/1486087028/jsshell-mac.zip"
  version "1486087028"
  sha256 "68ade82a1f5840ef575af51cd25bfc09a623049e35cb51bf6f914269701b5d94"

  def install
    lib.install "libmozglue.dylib", "libnss3.dylib"
    bin.install "js" => "spidermonkey"
  end

  test do
    (testpath/"test.js").write("print('Hello!');\n")
    assert_equal "Hello!", shell_output("#{bin}/spidermonkey test.js").chomp
  end
end
