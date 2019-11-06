class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.50.1.tar.gz"
  sha256 "aba9aadd3d20f8684a0150482011a8f9aa36feaf31d987660912378e7892553a"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bc9d7c6382f1c06980065d4e66f951ebec0b1b961946ce594fa40976e2421fc" => :catalina
    sha256 "b8f542dc29becb4b357bbeb456886dac9376c6a55188d92a3eab7441bc9b1b5c" => :mojave
    sha256 "82f76873b2b3dd5a169fc14984dd5fbc1f758016ec1ee926db8463d0e93b89b7" => :high_sierra
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
