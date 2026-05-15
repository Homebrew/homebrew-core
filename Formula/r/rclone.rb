class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.74.1.tar.gz"
  sha256 "aa0470151fe2e33d6bb96657892dfc4d56f92472a2dedebdda4ff296e87b79dc"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62d00a9b9161d6557228fe81510f5f6fc80426d4521644d63b49207de6e35b11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e52a28224109c0e82dde43c6e88d0a8824b6bb06d203cd48102ef2d917e05e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ccecdbc2fafae824857a7d9924f1ef405212c7745c533130732396ffe90696c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f7ea8512a9ada81d6273464bf7b0fa5a78df15da05a062d6f73023864f27f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f9daff5829b7985cde5ad65cafdba1b4843b6161fda518212d2cef9cb95de24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a20e759c33811d8fc0b70a85e6616f41e90c284b314f611cac93632e7f8b649"
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
