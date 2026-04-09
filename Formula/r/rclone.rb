class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.73.4.tar.gz"
  sha256 "b68b5c55bac24ccfd86fd4b70f722181a689fb6ea2b1cc2ad0bd53de94c4ef99"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5737d5b11007e6bf8e1d8b7bbd2ec21f88248c1f56f6ed3c206d4233c41562c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d56be510be9e36a4f1ad09b4583996c832930dbd5527976caf9a33da3c87bd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "17924e7439b1cf1499d14b0c1f960d3a8f23be13316a81f4349befc49d471902"
    sha256 cellar: :any_skip_relocation, sonoma:        "9bf0c2df3ab7390373004018e2cf913f52100684bcf61c9dea32216329c0fee5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04f17b4b213d665278087a86b4bee90bd8c3e17430bf0ae4c6eca2d1145215de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f706ac6cb0d01d8bfe3f69d72b0d62c4cab27be5d43799932c952ff4f7bfcd61"
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
