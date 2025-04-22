class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.69.1.tar.gz"
  sha256 "2fe258d1b4257aef98b53794c27d1b254ee0f2e307634f94fbf3c71786e3b1b5"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fdbb9d2d564721b13cc5296527cfb25140d8c699bd8b063d818e8b4dccf49dda"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a1066862490c164eb51bf93c29d0db794be99c7199b9e6c872a67e78e1fadb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f20745a0f87a9fa79f8cecd87ac9e1520b6e898fa1bba064f74cae6eef184d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "77ebad89275e6bb3e10610341fd81f7542e63d968620c5dc84a6f9e4e32cfc74"
    sha256 cellar: :any_skip_relocation, ventura:       "1a49f175cf0fcfdfa6d1f18f3a0ded73f8850d919964cfd746db59b04c5a1fd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8495432c0f417b36108c3681d18e9ec56622eefcba051962c2ff4071fd84897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16b80e630e9b42c842267747c179e35d9d52be7dafde956e161bd021841d8614"
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
