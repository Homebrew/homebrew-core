class SignalBackupDecode < Formula
  desc "Command-line tool to decrypt Signal backups"
  homepage "https://github.com/pajowu/signal-backup-decode"
  url "https://github.com/pajowu/signal-backup-decode/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "e7727b6628004cd027e374bcd8a004d8c3e68b3ba03e82ce2c9e04ee58623ed2"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "false"
  end
end
