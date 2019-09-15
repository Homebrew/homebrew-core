class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.3.tar.gz"
  sha256 "ab5106f38703019f06246b94e9b8271013b8064fab1d5a4e0f09f5ebe34dda4f"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "73e0d557a9345553ce68a17197958490baf9c0bc1fa51b47c8bc1909347fda54" => :mojave
    sha256 "18a53d96f16d51cd4d11b85abb065aa84b5145e738f5e445235428814d9f2470" => :high_sierra
    sha256 "a67f2d4655344dd7d6087c2514ec17ee6bc492b679fe15e995d968391d845ea6" => :sierra
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
