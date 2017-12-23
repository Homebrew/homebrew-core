class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.39.tar.gz"
  sha256 "1b87291aef395209dec01084f44790d216fcd0440c5d8a9ac19668704f05ece9"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bfb44718ae89501168757b15cbc2c82bc51227062cce22f28e76e2248cdf0ad6" => :high_sierra
    sha256 "4c39af5411641051b8bfbfff8a11fab52edefd767020539bebda9db25ee398bd" => :sierra
    sha256 "3ba189ad018bd4594b8d17e3657637258418ab5820aec6169e1cb107859acfc4" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
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
