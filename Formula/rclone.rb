class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.58.1.tar.gz"
  sha256 "b1fe94642547d63ce52cdc49a06696e8b478a04ca100ab4ab1c92ff7157177a9"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce8c496e927b38b9885bf055e06739958f297d1e24bb20b0d202cccfa5f81c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec8e433706e6f01b732ec4630f5583819b2fbec2ed2553a0c6d92579aa5b4b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "cf88bbe948983de3f057fdb865bbcaa4a56b908694066f73f6caea3171003682"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4b4384c3fc7a054202d6f4b8e1e38d58a96f77ec7b1d1d05e1087b75f22c32d"
    sha256 cellar: :any_skip_relocation, catalina:       "9496d0c2066f3326d6a08ae11b8bc7797a1612ac520c3c271176aeea678b60c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c935841423969eb7b495912305e81a72d8ec2fbf479ee7f163f3791c160120ad"
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
      Homebrew's installation does not include the `mount` subcommand on MacOS.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system bin/"rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
