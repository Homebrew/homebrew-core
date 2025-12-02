class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.72.0.tar.gz"
  sha256 "5a2eccbc3519224377c0fbbf4469c6e8125c37616ac28cf3c3ec091ccfbbe0c5"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c7e9bef70678860ba6a6c40358e9054c6ade431a78361a8ff5a7f6cefb4b603"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7061ed82ebbd9ee8b7100dcd13be0831bb5f38e275ecc191dce30ff2f9e889dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d997368dd09d87d6b53ba67357e0b67c10696e61a8903ecb2fd95b7f498a416"
    sha256 cellar: :any_skip_relocation, sonoma:        "647ad2abaeca25ed0a919ba2f6ebad15800a4c44c8f6744719a4431b09412f42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14db2a93916b8317cf92a2f06c30cbd4458a4d98afc54b98fca08c87b2a6db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d37ad4e9039f1d9c6d111249fea0299f9d997fb7853ca68212ca43c2b49a42"
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
