class RsyncTimeBackup < Formula
  desc "Time Machine-style backup for the terminal using rsync"
  homepage "https://github.com/laurent22/rsync-time-backup"
  url "https://github.com/laurent22/rsync-time-backup/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "567f42ddf2c365273252f15580bb64aa3b3a8abb4a375269aea9cf0278510657"
  license "MIT"
  head "https://github.com/laurent22/rsync-time-backup.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f5fc0d52255efff1f05d7820ae5c155fc59214934687e00e805911fea20ca6c6"
  end

  def install
    bin.install "rsync_tmbackup.sh"
  end

  test do
    output = shell_output("#{bin}/rsync_tmbackup.sh --rsync-get-flags")
    assert_match "--times --recursive", output
  end
end
