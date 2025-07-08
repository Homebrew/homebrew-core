class TtyAirdrop < Formula
  desc "Send files via AirDrop from the terminal on macOS"
  homepage "https://github.com/su-mt/tty-airdrop"
  url "https://github.com/su-mt/tty-airdrop/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "944a31b7f78429723d7efe7ca93a1e97f1b03d02e7718459cbcc4fdb1ae11e28"
  version "1.1.1"
  license "MIT"

  def install
    system "swiftc","main.swift", "-o", "airdrop", "-framework", "AppKit"
    bin.install "airdrop"
  end

  test do
    system "#{bin}/airdrop", "--help"
  end
end