class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.70.3.tar.gz"
  sha256 "0b25fb9f0cb26883cfa885576ddb34276564a1e224edc5aacab826f9ba22179d"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88f68f773f201fe8519cfd5f2f43e19b6b031e6dff9d80769f6d9c33435b3d67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfd8d19db35ae2f3ffd6b0aca47f7b7dd15bf156c5b39cf303fbc2272d20933f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f821054e37ea2730afe194e78427e17fcadf4dd1a394f500af0d90f1b1539d32"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b1da20eb88b913ffb5614dd7bed8571ec63c751d6516fceae47a00d44ebb05d"
    sha256 cellar: :any_skip_relocation, ventura:       "5a147b19d298a6d0427b291261e545e7a7647c10933cb1a77d318a8e5e5d2cda"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382c43672dcf92de64f20df8bc02e13e7ab1ce674de7448afa6275117f764440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f35f2c6c2fed7316c6d8019c7eaba52aea9d0f2f37905a8e63b13846a37a4d63"
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
