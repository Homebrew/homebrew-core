class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.50.1.tar.gz"
  sha256 "aba9aadd3d20f8684a0150482011a8f9aa36feaf31d987660912378e7892553a"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2664279c78128cf49abd8ed8f36f81939c4f6ff844d470eda916f6719f36982a" => :catalina
    sha256 "822807a26e15e713b8761188777effc00c3ab6c39037183e7e1b217b134e7413" => :mojave
    sha256 "11daaf06fe25bf93bed5115dfaf3f527812864eb3e938a95bbd64c6ffa6deefe" => :high_sierra
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
