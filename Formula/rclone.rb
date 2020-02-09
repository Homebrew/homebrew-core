class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.51.0.tar.gz"
  sha256 "5777976745ecd32b8fa355fda1ba45c445d1c6b7ffbda5ac126479a937887b11"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b56453fcde4d2d35cf467afd37d5798d332c3b666d74d7945c9b8df6e059893" => :catalina
    sha256 "947a6aa9692f716501316c370eef83e0d87042edf86d4d1c99ac7b99e27b27ff" => :mojave
    sha256 "cec3a23f8fdca70160d15ef04eee1126ab208553c548fbfe7fe3f9d127711046" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    mkdir_p buildpath/"src/github.com/rclone/"
    ln_s buildpath, buildpath/"src/github.com/rclone/rclone"
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
