class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "9249391867044a0fa4c5a948b46a03b320706b4d5c4d59db9d4aeff8d47cade2"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b88be11a6b79ee338cdc93438405a67f9b5340c57463a6ef7eccdd10ffe1809"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1fda558b72400157ccb03d307ee8bcc431e0e3fa6af22198efadb34fc50e977"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dfad3c8cd84b1fee6200e2f5b1c7a0595df6151e64ecd1e27fd0199abd327c7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d74020d457ac055473afb81f938128a5cb642a5059188b1a046acdfa7e0954b"
    sha256 cellar: :any_skip_relocation, ventura:        "f277299a72eb2a00bfd3c8029722b3481f489b3e9edaec263bd317bd9a6cff4e"
    sha256 cellar: :any_skip_relocation, monterey:       "4cd8e5f4e4594c1d78811fd3d8c513bb8c2e27517f1efcccf1835d907da0233d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9581db687abd37e6ed162059ec97bd1615d0bc084f45fa5193a01e7f30ac87"
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
