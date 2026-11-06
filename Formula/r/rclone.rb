class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.76.0.tar.gz"
  sha256 "8cb7e5d576fe9a3aef8b1a0785e2ffc6c1953f8ed109f42000b0b86718f6628b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e9222bbcbc32e6fccacb45a6f1624d4019faee553efbf8e93824c0ec4229db49"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0c596fcbb3a8697223402498a227723ddf14c295b71b675fd5d85448cfa8785d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5929f2f0dd6357480d68bfa6b504238b36f18ea87bd82cd5abf29f7f27b73975"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e24177880dfbf79f67dd4d222d24d3fd16099913ff2a43f44907456835e831e8"
    sha256 cellar: :any,                 x86_64_linux:      "5291bc9d3eab2320b23a2e08c361305c45940cf81fb9b1ab96514547a822da88"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
