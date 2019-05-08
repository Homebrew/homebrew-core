class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.47.0.tar.gz"
  sha256 "7b6246d65d17626e35ed1727f01afba823cbc14d6db79241a385151a0b5ea77e"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40ca2b3cdc267c8ac6db09b7257c15a1550d84d116e854ecdd4054c1c20a1ff9" => :mojave
    sha256 "88f0ebbdb9339ce644969e16b1f0054520dea1f5711647be7f6fdf8a914bbcf1" => :high_sierra
    sha256 "bccbad5a7006ebecffdb8c2c0a130095b723b85d425dfdac98491ba6564a3d59" => :sierra
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
