class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.37.tar.gz"
  sha256 "a74e284d2368f6fb8e4ac654a31b9b1328ac6078acd3446c9a892cd4bcbe8660"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3620712255134b1c9d2ee003b7a24ead0c3442fb5b978d10e89a074aa4d5b12e" => :sierra
    sha256 "c82062a1b60bf6c721615e33184529387cedd639453f7e63ad2762fe9d90210c" => :el_capitan
    sha256 "aa03f9aaeb36428ec466dcff39256df1446723f3cf45a5e180a583d5a076ade3" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ncw/"
    ln_s buildpath, buildpath/"src/github.com/ncw/rclone"
    system "go", "build", "-o", bin/"rclone"
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash_completion"
    bash_completion.install "bash_completion" => "rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
