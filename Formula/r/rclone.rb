class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.75.1.tar.gz"
  sha256 "fcc9351ab3976c73b4824cf7919f98f911f2442a606e2910fc2bd562111da220"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78f829e872a2cf2757f66502239928bcab3d7cb6fb8f0d16adfd201dfb52ff03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3699a7a9dbc929eb2982767e6f6c43adc25726ffd6586b99bd107eac83a748f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69e48179feccb544567f5ff3b81c871fe6053189f91710b49c9312552f19d2f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc84378db8d922f9f0d932716676dc4c67e4452c827cf7d53f7e26285f10032c"
    sha256 cellar: :any,                 x86_64_linux:  "15fbcca86cc4db10eafd1db3fa91d4678e060a70db453e9bdbeb108c72d0c873"
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
