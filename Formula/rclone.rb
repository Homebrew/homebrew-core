class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.3.tar.gz"
  sha256 "ab5106f38703019f06246b94e9b8271013b8064fab1d5a4e0f09f5ebe34dda4f"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecdcd8bfca63105266cc47a87d93285787d35dd5f8f06399f33efed4ac4a74c6" => :mojave
    sha256 "901bab8fd8a93eaf376fa3ca91b80ed4e0e7fb8da65f125b1e394ba7aac6fc17" => :high_sierra
    sha256 "01bd341a6b8d9a32864e563261c770da2ce5797fe583c465cafd28892af8adae" => :sierra
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
