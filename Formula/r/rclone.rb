class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.69.3.tar.gz"
  sha256 "ff6d17d187dd23648bfd33f20ff48902f7f08d2d9231f1f11825109903356b21"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a68f9f61f3d375d71ee51f276d0a22d11902ea1525bf1aaa0cf6a14b2e40876"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66d574b317412061e35b3f5dbe72d677dc1147c7642a62bca721be6df4d4f8b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "180411120c0caf156d73481bbd7d73553e30cdf9e6ca611cf49671652ba2d57a"
    sha256 cellar: :any_skip_relocation, sonoma:        "655b770e1560d1fb67e2c53018425420e25733f40e145c272eeffe0df3d68c3a"
    sha256 cellar: :any_skip_relocation, ventura:       "2246e2b974c8c6ef03a6509434dc2d47f583403288a5accfc9eb418ffa08047e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8111eb9652a49b8b70a5f391414264988ab0a00d2f12e1ebf912f3a58b45d5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53b4a81d1083edcbac8f53f87017952c76826b09399ea6eb65620a781f11fba1"
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
