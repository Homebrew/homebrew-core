class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.73.1.tar.gz"
  sha256 "8aefe227099825b5a8eeda44a2e1623b657914be0e06d2287f71d17b0a4ed559"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10301dd90f89e7527d801afc309897571b75a7aaeb5629abc7d4ef9c89c37ae3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cff63ecd9c8dd3cce34d0b61e52b63c6856b3edc3ade83d365983e7c7c4a3b8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae23b4ca9d580f71a50b735a600b87622c6d61539a5b2e2245f792c58b24f2cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcb6f766dc553855901e7ce8361a362262708e5c340577e369b2fc61d1c14c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d28c51627c256e1e1fb23cb3482f24fafa2cbd1123be4ccde400c56283cb8dae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2242f735e1112cd8c61eb4c3c425bba0b7a189a12a28050c3427ee80667548ab"
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
