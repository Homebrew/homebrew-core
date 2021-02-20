class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.54.0.tar.gz"
  sha256 "483d0731e3fbcdff33934784a8d39706f07358c5c8eec9136ba31458f775958e"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "520efd2c8538f0a7e3ba7f6e07c8d877242ad307779426b033a88ab299e1727d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a8b1273b078ef2c44332a3392d781132bd747713035ead1f8191826ba8205859"
    sha256 cellar: :any_skip_relocation, catalina:      "6abdfcb2c466314bc3da7a5d9c71096ca78b48fd0851107f29e6fcfe9a46ff1a"
    sha256 cellar: :any_skip_relocation, mojave:        "8b173e5e4e6665b5e00c9a40ff435e3c2224fe5e2f4bfb736679a564d90c6921"
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
