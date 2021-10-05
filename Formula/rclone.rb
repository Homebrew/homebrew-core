class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.56.2.tar.gz"
  sha256 "a5b0b7dfe17d9ec74e3a33415eec4331c61d800d8823621e61c6164e8f88c567"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "957e720c43d34dab552b432aa5b7e1c1f8248fcc710636bb7d0f9ffc04865539"
    sha256 cellar: :any_skip_relocation, big_sur:       "33790b4ad68970d136d97859a771bd12ea17eba644c70a64ac8f848e7adbefa2"
    sha256 cellar: :any_skip_relocation, catalina:      "89eba48543a11570324e2a96e56b0962486969fd34ea07ff41fb278769dfe2f8"
    sha256 cellar: :any_skip_relocation, mojave:        "4d4d8134ca7c9cd27cf242fafac39c1ab90fa51ac592d47d02c1a87b9e0daf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e53ec3ae829bd6f86f8d83d332ecdedd53e1bc16646e3b815cc85b3fc8002c5c"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args(ldflags: "-s -w -X github.com/rclone/rclone/fs.Version=v#{version}")
    args += ["-tags", "brew"] if OS.mac?
    system "go", "build", *args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
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
