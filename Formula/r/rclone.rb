class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.75.0.tar.gz"
  sha256 "1292c5fae9d10d6df3ea0c2ba96de42336e96e2e878729af1f02f86900434ee0"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4593a958c54d62c0012f7cd27676c00b65a9cd57527ef1485dcf439f29cb744c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0901ae438d09a612590a6bca19ac165ace4dba5b6758089a64dfb735fd9bf51d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ad660f04546df78a3b13daf1a59cf6b0101e6e76d7a17996b5563588c0a186c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1f1e7dd21ea5593a2f9af0b7fbbc70c3216a660a09fc3b18efac8684cc0663f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e69e03b9bce403899d93ca85ce123f0949355acecae30a42a4b6041ee9ada911"
    sha256 cellar: :any,                 x86_64_linux:  "53f9d3865f0c353bc23fd267d6a0283a3d06ef7c795ee33ffe936ee716a0ed33"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/rclone/rclone/fs.Version=v#{version}]
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
