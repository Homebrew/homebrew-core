class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.1.tar.gz"
  sha256 "0cbd21f4d883d9293f19081b4f47407610cef287362d0d18752f700de661432b"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1637acc9b5fc3d204661d318e155223a9d31a02d739932ab438d60cc5cfa689" => :mojave
    sha256 "d6723c7dd083f09e917e87a6df3a74398ef63d8af48f8c5f8f99bd4151fc93e9" => :high_sierra
    sha256 "6d3c6070bae85697abb85c7bf60f6cd7c314917aa2f47011e4190832aa7d7b77" => :sierra
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
