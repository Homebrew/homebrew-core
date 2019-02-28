class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.46.tar.gz"
  sha256 "4a5deb7b7aa8222be9179c12d497b6e48af55d76abbd671b6fc2d6d1af8c88ea"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e22b0807a4757cc4b191e5f446174a928fe5c6dc7d8ee2fee8c87cea1377a325" => :mojave
    sha256 "452ad7d118ea50ef82f152ac3803461237af1b83259f3e8152242813e518ad6f" => :high_sierra
    sha256 "e60c59417ff271fffe0a2fdbb32349b0b760a10af62daa457a31922d94a48514" => :sierra
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
