class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.68.1.tar.gz"
  sha256 "26259526855a12499d00e3a3135ee95e7aeb3ecf2f85886d8c837a2e7b236226"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82b882393191d64add101a4ca9757757e41decee662749784710add138a15480"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be9c7437c9edb198c8590db9777aa33d0049266c631a1eabc4455341b3fca11"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ff458becc764f1fa737160b2754deef05f957215142ac5a3195b1609d32920d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d73b8b4bf9c7615c8f50f4f07ef70a87a8f99d9a5a7ea65d8a7313f51e49f542"
    sha256 cellar: :any_skip_relocation, ventura:       "f73b6de31b16de94d88729ce0229a554606bd6cef3b2ef02951efa6b8a6f1ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43f98a6d4e58cc834056434af23238dfb81cce633d7fea84190f936e5b04e808"
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
      Homebrew's installation does not include the `mount` subcommand on macOS which depends on FUSE, use `nfsmount` instead.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
