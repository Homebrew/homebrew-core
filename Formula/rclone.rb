class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.54.1.tar.gz"
  sha256 "432ac3e9d10c5d36dc17e2111386c71b3bde7ae697604d8e257a135fb45e7bb4"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0c622cfada3f58e07f4bd86e011168773ee989db6cacaaeed80f465f3a332fbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "50481ebe8dca697a93c78e9ddea19ec902ce8d51639a48ff4abc4e7e17cba924"
    sha256 cellar: :any_skip_relocation, catalina:      "c4baf5197b4d6b375ed1ac6e526f56c1ca1aa69170ac0ceb481254b0f3a5d8c8"
    sha256 cellar: :any_skip_relocation, mojave:        "faffe9ea3e6c01d237e7014e72cd4dd795ed42408368cdd5b607f3f4f975f06c"
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
