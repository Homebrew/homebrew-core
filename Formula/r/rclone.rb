class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/refs/tags/v1.66.0.tar.gz"
  sha256 "9249391867044a0fa4c5a948b46a03b320706b4d5c4d59db9d4aeff8d47cade2"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df5445aa5023e5c8b652f22fd235b82965e20a8b1ea43f115b49f250703c8e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "589eee44ef41acf83429cfda57d5da8611f5c4e29b4f1e363640bebb8d29c669"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15640c8a84b819167cc0fafa68b6b9f5099e4f1122384c239172ce7fbe0066bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "bcb78afdb412c65fcbc6124d21effdbf2e637836f212fc42cbeba83867094e50"
    sha256 cellar: :any_skip_relocation, ventura:        "0738a3b479dbd8330a0af27e00550e4b0df31a291b17c6bb7b1bd61b8f6a4e54"
    sha256 cellar: :any_skip_relocation, monterey:       "2ef444781a7b86d04ca13c7537c974e0dbeabdcdfdc0c280995215e2b28a2015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a4f88762e749dc1663464d2a9fe9af229cf92e64649718fc742262fd9c87b34"
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
