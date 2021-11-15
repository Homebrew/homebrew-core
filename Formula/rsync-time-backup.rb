class RsyncTimeBackup < Formula
  desc "Time Machine-style backup for the terminal using rsync"
  homepage "https://github.com/laurent22/rsync-time-backup"
  url "https://github.com/laurent22/rsync-time-backup/archive/v1.1.5.tar.gz"
  sha256 "567f42ddf2c365273252f15580bb64aa3b3a8abb4a375269aea9cf0278510657"
  license "MIT"
  head "https://github.com/laurent22/rsync-time-backup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df2bb4640483ca995b709e9f6138f6cebf2a2d6e35bb8ac3ec86e2490879d290"
  end

  def install
    bin.install "rsync_tmbackup.sh"
  end

  test do
    output = shell_output("#{bin}/rsync_tmbackup.sh --rsync-get-flags")
    assert_match "--times --recursive", output
  end
end
