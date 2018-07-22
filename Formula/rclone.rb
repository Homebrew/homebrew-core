class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.42.tar.gz"
  sha256 "fa84044fd387b7366de1234fba073dacd0fd7015b36751f3ec18514b704a2fd6"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
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
