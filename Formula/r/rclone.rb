class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.71.1.tar.gz"
  sha256 "a3aa14e37047081f9770d7c58a0f13e665ed99600259884246b1884fc4b30b6c"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "725fa190261925851b8627d9e365064707686d6599fe679d62ff2de562cd7e2c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51eaaf5906e89f5e8b196e454267504d49f70e2fc0a1795bff576a1f123100b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ee964446acc59783f337182059fa12f1bc5c6c28b8bcc3f7ab93842b90c2aff"
    sha256 cellar: :any_skip_relocation, sonoma:        "691378235f122c56657011b631283b76190b6cdf576eada3e3c707c6d5ddf440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a897ec7bebc2925f8b864c9a389a03a150a4414cf97945fc435efb118ea033da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5592b1820217b718910cd7433d8b45c0ef5c09b66bf08f730c304c2a8b766c9"
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
