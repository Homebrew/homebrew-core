class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.49.5.tar.gz"
  sha256 "f151f814436365ef92f6302c555efa3bd490a74a5dae26f325f61a7a7783838d"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6351f1dd3c2e9c7c21882590be6a49cfb3dfff76282a0f353064361ef46421d3" => :catalina
    sha256 "1c6e8d332cf4f102c1f0cee083d184f911afd429a0fec7ab3c1137f8db187ee1" => :mojave
    sha256 "d8eacdcf8416c2df282acca4595d3175b5abec239ef81bf1bc55afeaed1ee128" => :high_sierra
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
