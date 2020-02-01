class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.51.0.tar.gz"
  sha256 "5777976745ecd32b8fa355fda1ba45c445d1c6b7ffbda5ac126479a937887b11"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0cd8efaea2e5e739553841b46a97bad74a19e4b44e473083582f3fa47090bb1d" => :catalina
    sha256 "c0263a49d6b0dd7510c0c7329d25a26d9dec656be2fd756417c66d80d10fcfb8" => :mojave
    sha256 "a72cd7c30dac6313289a9c152cda77859756fe15ee17a268c2f69dea8eb3ce8c" => :high_sierra
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
