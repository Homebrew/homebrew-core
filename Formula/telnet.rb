class Telnet < Formula
  desc "Apple telnet built from macOS 10.12.4 sources"
  homepage "https://opensource.apple.com/"
  url "https://opensource.apple.com/tarballs/remote_cmds/remote_cmds-54.50.1.tar.gz"
  sha256 "156ddec946c81af1cbbad5cc6e601135245f7300d134a239cda45ff5efd75930"

  depends_on :macos => :high_sierra

  def install
    system "make", "-C", "telnet.tproj", "SDKROOT=", "OBJROOT=build/Intermediates", "SYMROOT=build/Products", "DSTROOT=build/Archive", "install"

    bin.install "telnet.tproj/build/Archive/usr/bin/telnet"
    man.install "telnet.tproj/build/Archive/usr/share/man/man1/"
  end

  test do
    output = shell_output("(sleep 2; echo 'quit') | telnet towel.blinkenlights.nl", 1)
    assert_match "So long And Thanks for all the fish", output
  end
end
