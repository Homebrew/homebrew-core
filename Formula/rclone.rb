class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.2.tar.gz"
  sha256 "72507c409eac49d716813639ed7e214c5130953cd5cce984b836e7c72c15a141"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bfd5169aeb4cf1613fff2c35416aec73e631d5dcb8b1c83b9057c4f1146a20a" => :mojave
    sha256 "a5079f1b2c5e4284b6293e80fb499e4c04d8596fa18a4b21ff18db581f2d0c04" => :high_sierra
    sha256 "c5bd7fba4e707a92be2460198d1d658d723d22af8ead36616a014b84ffdb89a0" => :sierra
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
