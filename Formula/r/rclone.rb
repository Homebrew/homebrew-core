class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.74.3.tar.gz"
  sha256 "3ba8bc7fb216f8f0307357ac67842467f453050468d5751e9269954819148568"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f1baf54b9a175d6d3fd5c23eba7c7c1c4cbc290b0b250e3cec144ee7a7602caa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d39b5ee2f1396fe49da4646d5193ac1ef8cc3d515a62166dd284347139fb6e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee6177d3571d081c31fd47fe23841f5c41e403732ee1dee4374cfd58c96f7ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "06a7ba46ac46a1098a6a4eb4c32c98cdd3ceb682f111df4fc7a2062e011261b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a8dedcc49a7f71dca831b0d3f7235b70f9c582fd3d5f9512101e9f2cf95f279"
    sha256 cellar: :any,                 x86_64_linux:  "5fdedf2a94dfa3f859bff7c53450e2591bd90c3c2ccedb1a837b423be9d9de35"
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
