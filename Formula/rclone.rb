class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.57.0.tar.gz"
  sha256 "294f7a6b0874509997d3a9ffae7c74f0c45b687df0ac7d7742f284ad3814fe55"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a0c78b3f0681ef282a94f63f0b2831b31e651804d9656f49570f9ef8978c71c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54e0cf13423a33958bc5956e2822cf2ae6e4f7e2d14c65f885f55cbbc2412535"
    sha256 cellar: :any_skip_relocation, monterey:       "3b4bf1b1bd288d6f2fb99f88af8db35c502e6ec65097388c99548ae801bc51bc"
    sha256 cellar: :any_skip_relocation, big_sur:        "63f0f3a09fb9e3af4f31df90274ae17685d3495f96d58b4af7e4f86e5ed1f178"
    sha256 cellar: :any_skip_relocation, catalina:       "da91f486e53d4aa07d3abfc423c8db7e20ea4ab806cdc8aa9285731ca7626bb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e244e55005936c8da0988b34f422e237c260c8e0ec0c3af4c8116acd48411d6"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
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
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
