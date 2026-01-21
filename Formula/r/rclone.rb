class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.72.1.tar.gz"
  sha256 "322c73932b533571880832c0e07abdf9492c7f329b7d1dcdbd2a195fa2635a77"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea7dc91584bac82ff0e4d1aceb4d09add4973e6b517e0f6e27fc6e34193eb6ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68057aa1780bf9c24ac8a98dc1ca1246eaaabc3325bb03a3a53b9b47d29562b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6aacd5425947c0fae123012f6d51138d13fa68b48fd17d7dcd9838066eb2a0a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4575b558cb787a2970dd1235e96f4b465e3c372b5ba97fe727807c5e5b1b851"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7091b1e162cf5d039bcaa0255f8eb749a93ada24c67af676b838cc41f44c4f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9b9c0fa08b71e5c6fb6d4facf8f79375691a48971961543005f3ebe114d786c"
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
