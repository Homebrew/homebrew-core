class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.75.2.tar.gz"
  sha256 "68afd7f68c84bd978966feae2116339aa7bf454b39c573910c462e87c3774d5a"
  license "MIT"
  compatibility_version 1
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec1a9edc575668f7e270d6d85031043bbc9e864ed2bc319131f70fc2e3297b80"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ce39db766c6d04bdf28923c24c660c79e4022d45569a204e8b84a278cabb7c83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fd60d91e5f19cc32664ef2d2029fbfb2ffb4ecff256d80cfdf7b5e3af7ded78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "42c92b2a5626523af6803ca93cc34f0dfe9d351efb83560ee0ee775962693723"
    sha256 cellar: :any,                 x86_64_linux:      "1e6cd463e0ae21d6274802c93d25284605ee5f441cd68fff2ef8373dbb5ca786"
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
