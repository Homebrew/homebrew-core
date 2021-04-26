class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.55.1.tar.gz"
  sha256 "b8cbf769c8ed41c6e1dd74de78bf14ee7935ee436ee5ba018f742a48ee326f62"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a1885d1fe4b3f3132bed934229a8f3f75a44839dad5136dc7e7dc6b936a60b3e"
    sha256 cellar: :any_skip_relocation, big_sur:       "96d0bbbaaaeffbe6f80745444f124528f52390c0f96abd7fce059572d30af30e"
    sha256 cellar: :any_skip_relocation, catalina:      "075931f4b26331aaa6ebfbbaf0ebc074b850800076140dc6bd831398389d4301"
    sha256 cellar: :any_skip_relocation, mojave:        "8068a9c51af8321602800886c3f0858c8679ea3db0f8bcfefcd9350dcbdc40ac"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args
    on_macos do
      args += ["-tags", "brew"]
    end
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
