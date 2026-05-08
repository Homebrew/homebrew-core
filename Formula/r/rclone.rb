class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "fac84dba8daf15112507adf9f7913a8e566969e485fb4d5abdc3b8f7974e853a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "435cd466a58d0181009abd3c71ba99df2fd58db26cf6e7863b98f278c1eada3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426f2f7547abf152303b83dd7da8d475265be5ecbd76ed7191402002fa1bb07b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7f19cba1f4af7b82b0751b759a12d2abed335e887910086f4c3435c9c0000e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe23b12c91cf111c73498e50495c7fdd21d457d3b841d954fabec29294766a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bb3c13d1c32c8d4043402122220af1cb65ce38a8573dabc055cfe020125cadf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f2026d6f8aa3bad8297f50dea6963d16c1519bf3c3470a58ba18c2fc0b614d0"
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
