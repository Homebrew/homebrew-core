class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.52.1.tar.gz"
  sha256 "09ec57d7b812972c15728b07c496b15db6fad4b7ac510b31fbb2cb2010874b75"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "785982ba9eefa7e63116f9069d6ae5c3230e4ae64cec240ddb5a6b845b57dd0f" => :catalina
    sha256 "3eeb890d37ea5d2a17aec72053d2886a42e3a1d06ec7d7f719cdf5be04e14199" => :mojave
    sha256 "977cc8f3ccf73ac1821d85659f9dbaa6c3fcf610afd49bcd321967a24e5e0318" => :high_sierra
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
