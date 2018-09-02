class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.43.tar.gz"
  sha256 "cbcd60cc09324cf9f8ad8491fe3351a49abfa835a652e7ddffbcd4a4b5f7de5b"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7457142ea5a4e25b32548ee40f5fc472dc5e46c413f15a0a05ac861af7a8eab" => :mojave
    sha256 "c5a24cebbff63e768439a63db1e824e2d68b3d1f1cb4b8721bfeece777756aac" => :high_sierra
    sha256 "f5bd438d038265787effce38849c9b9d2b390516a9aac38b3130e2f7dd5feafb" => :sierra
    sha256 "098a51e85a1bcaeac18295e55678f1d5345fbbbb44875b6320659f540650eb97" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ncw/"
    ln_s buildpath, buildpath/"src/github.com/ncw/rclone"
    system "go", "build", "-o", bin/"rclone"
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
