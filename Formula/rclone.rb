class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.42.tar.gz"
  sha256 "fa84044fd387b7366de1234fba073dacd0fd7015b36751f3ec18514b704a2fd6"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad45a0e0f7b2d7d5895696e1ccd34a7b40fe1d57a51e61235887f24967248a22" => :high_sierra
    sha256 "5667dc9f1eb3c147ffd55502847640f191df0c6b2d8e734058fe6779b0c1308a" => :sierra
    sha256 "cbd6c6ec1b3bc1275400fe78ad7502613bf51d717ad306f55d4ed07132d19654" => :el_capitan
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
