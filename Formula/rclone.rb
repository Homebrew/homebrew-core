class Rclone < Formula
  desc "Sync files to and from Google Drive, Amazon Cloud Drive, etc."
  homepage "http://rclone.org"
  url "https://github.com/ncw/rclone/releases/download/v1.29/rclone-v1.29-osx-amd64.zip"
  version "1.29"
  sha256 "64c95564ae69f5238000c6adb2f4d178923176ecfd9d64cddfd80bfa538e1c15"
  head "https://github.com/ncw/rclone.git"

  def install
    bin.install "rclone"
    man1.install Dir["*.1"]
  end

  test do
    system "#{bin}/rclone", "--help"
  end
end
