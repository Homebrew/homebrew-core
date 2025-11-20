class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.71.2.tar.gz"
  sha256 "54c619a2f6921981f276f01a12209bf2f2b5d94f580cd8699e93aa7c3e9ee9ba"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1289bd9a45b4ca1694098faefa19b596fca0324975ce1cdbe89f06780c6efcf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cec19f7c376ff64f51cc015a8e0c0f1ead389867e5f809165ee8879a19dd2425"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7ea1deaca67fed388d5d3a4f0e3427d12ba42d8d0410e3ed8b98471fc8b1259"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fb7b55f5ea8f658fb23a205b99c4c2c29ce65ba62ee2e84d7dd14bf753d5dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a18e5e2fd08cddb6a3b2db179a197ad5ea4c50862ff4227c15190362dcd8d57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a926f2d8f33a7369adbc7a4d051881855cde027c098fc4a8d54e224ab55fdd94"
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
