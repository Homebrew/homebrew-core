class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.67.0.tar.gz"
  sha256 "4ecf2e99eb98c9bb678be5b0cd28550c4a2a2d63b5f2ed66962a4f4b9b36c402"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "16a141694f0467c57fb854c7852612b175934de2bcb160501c8b4a7859ee4be1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74c7cc2cc55806f8d862e99963b70a85665ae83c919a6e976cc5d747c20345e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5beb9eb6015975f06211e2a70bdc3ca8341b6ff951355452d5c17eea898785b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ea7f4a2bf307a61aa02c399a346ab4e87faacce0afc2921294a9c47b101dafc"
    sha256 cellar: :any_skip_relocation, ventura:        "06bcd2b8d0251d585547fa289445b653af28f71bbd5c5c842fd2591439b41e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "e6747e23294fd7859b003106882cd750825f5c236e9c79fbeda03672dbd512ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f792c9f188b77bf81f14fb6001b9ddb813ab92ec16f63c3072302a0c99df8684"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
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
