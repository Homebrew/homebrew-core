class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.59.1.tar.gz"
  sha256 "3eb56502c49ffe53da0360b66d5c9ee6147433f1a9b0238686c1743855cc891f"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a51b5633a609e4a679bef1180c896f5d25a65232fc0a4eba49e02e07e6de15b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0725e1a3a7408045af86aea6962f04cec1777cf650d5cf0537635a3d813d164"
    sha256 cellar: :any_skip_relocation, monterey:       "c599947795261d542244fa45a9783bfac5d3544b8325a26eeb81a5f5629eb461"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf34f1f0dd6d24f2acb4bcfbf4e8bd16febc0e2eaf2640fa2475059f886c9896"
    sha256 cellar: :any_skip_relocation, catalina:       "29c69345db1a8ee0b1baf8e5fa82e8ab7f6af6839a0e7058012fbf3f80d231cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "161212a74e1dadf859584797f739ef3af838c48ec3a07e1e6cebe1d9befbb4ff"
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
