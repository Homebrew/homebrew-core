class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.73.2.tar.gz"
  sha256 "1bbb94dedf84fff7bb769a40fafda148d5987f97e26a3a3ceef08dcf18c7e534"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5553e81bd020ada84540300d10b573a413a87dae23016b077083133f8e1e4c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa5f7201c63637bbc6ee82403db27f0cd4d515a987456d4440e367dced1127da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe8f3946dedb97df1b85a84713221e4e792b0de1062b324108546c6e1fd19c53"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd4e026ddb0bade33bc6dea6b7142a3bc09864276c44e523e70ba74e2d67a425"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0faea04ca428cbdc8ed3643bf254751174049b92e97ded79b2a664bd5bb44036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bea33396903d3b5fe8c69a756a85914dded40a2312048cf1a6d95f5b0e768561"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/rclone/rclone/fs.Version=v#{version}
    ]
    tags = "brew" if OS.mac?
    system "go", "build", *std_go_args(ldflags:, tags:)
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    system bin/"rclone", "genautocomplete", "fish", "rclone.fish"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
    fish_completion.install "rclone.fish"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
