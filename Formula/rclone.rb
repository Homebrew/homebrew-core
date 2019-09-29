class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.4.tar.gz"
  sha256 "d21baf46551d9f3ee33dbc921cfaac503b0142339bdcc75eee973f7ed4b7a354"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5d043816b099dcafcc5704be18ba48451bab7b4588bdb1449e76545a79f90afc" => :catalina
    sha256 "0d0f03eb61ee59f6aef552ca0c6f9ca4d8c2ba7cfea5969c6a13c3c9224f4291" => :mojave
    sha256 "67d54a80074c825ba01b40c4873c26a7cab4eb0cb83aeafb50f47e2b2ae7c42d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
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
