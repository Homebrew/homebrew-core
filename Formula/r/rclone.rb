class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.74.4.tar.gz"
  sha256 "b8279a31a5249e4aecf04acff744ace4a2e3a169e4539a24aa67a9994f645d3b"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4fea481855fc397b8c6c998e67478b76a0ffacefcadf062f1aec668284f8e969"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d8d82c1dcfb071a4fb0124f58debc4c83eff10cb3a172f5c0aed3e424e32b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fc3d63cebd7d95fa153f446e5bd265810b1afafaebd6bb2d41bc3022ef9722b"
    sha256 cellar: :any_skip_relocation, sonoma:        "07a5061c2a36dcb34043fca42649f7c90fdbfd56b73940b29f003e4fad3bd6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b06dca739c6b27b250e854066b4e42881c3d51615dd716e783b31d8d7d7a3c6"
    sha256 cellar: :any,                 x86_64_linux:  "8ed99fb857f769a5998bba731bd825523c5a4831219093c4f9197c2819d549b7"
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
