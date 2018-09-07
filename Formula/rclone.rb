class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.43.1.tar.gz"
  sha256 "23de9e831487c4c5f1ddd3a5ba6ca72f9d93175b0c4a3bf85f398a2397fc92f5"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2862460140a66c4685077408b32512ec6552c0e6f4d16906cbea7c34749e9be5" => :mojave
    sha256 "b189c742c8931005b5947484e743e124948904abcae9178f3e863975942e9271" => :high_sierra
    sha256 "af27253e1ee06d2bc2b7b759ce56433b54d36d20900f381f3d626a1519f9c6c8" => :sierra
    sha256 "4ed42bc263281089374d9fd0a644e2d7a1f99c71e2bba9f7b16da6df46a25a09" => :el_capitan
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
