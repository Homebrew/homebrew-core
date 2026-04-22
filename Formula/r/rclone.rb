class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.73.5.tar.gz"
  sha256 "e52541bc238dd434a0335f467697d7d9575529698a74aab534ad39b8649f8a49"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a72b0876fdc29dd0ec25b99c22fab96fb0cbfe4a24f9fb21ac7ec8682f28ae3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8643bfc56cfeb510a837f340007b2060e36033957e9e979a14dbec3377ac148f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0259030d92c3287cd5bcf372c7131ca1a2e5bce4f8231cd0c50f162863883a58"
    sha256 cellar: :any_skip_relocation, sonoma:        "c63534a72dd83b4e04fb668bbd518a84e681502e52244abe4ef6111d155ce8b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2fadbde92b7d82ae13005945ea75aef859371c1e2d6f89417743b60ebae9634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2e90819f16c8f27b13e23611a740e3a33ae811b3ae7b95d76d2c4d71de80cb9"
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
