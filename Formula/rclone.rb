class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.0.tar.gz"
  sha256 "c753a2616ad6cb69703555a94dda634c76414d0d7f6cfbab3921bfc02496cf9c"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7669148a6569140c6f74c48606d77415c9f08f37b0e0a58f8078332ff7e7a8ae" => :mojave
    sha256 "7f7a8fcb13df108936be697db8a2cbce6369c63f098a478ca46566fe3add3f4b" => :high_sierra
    sha256 "885b0d403bfdb83cb0f2e6fa2f52575f4f7895361274cd105eba571e92d3bd8d" => :sierra
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
