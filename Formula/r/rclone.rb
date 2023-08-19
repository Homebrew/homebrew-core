class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.63.1.tar.gz"
  sha256 "84b2b2206abc3cb56056c0b76cceefecef0b5f6ad86b208ca458675632f0edf6"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "020e5b657d67af4b19b939bb5a36d05f95f8b84912927776dbdd3f51e982babf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3519783f3f09547f30004a2865a1fb5cd3eff3741fcfa4188f072e63a4d7859c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "27ca452d1e20ee61eb1c05d5080059b5038273f3c102709d0f4426a6990faff4"
    sha256 cellar: :any_skip_relocation, ventura:        "acf44f149d7620b5b9b2ee1221ff67971ee5e1ce10e71aa1d1a3da68b3db919d"
    sha256 cellar: :any_skip_relocation, monterey:       "6ee9165a147b65791c34c8620ec519b3a31a36bc91b1f27d8c0b1684469d40ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "8814b0617eca7edf7c03f4e568ce26d9b3cf2aebce94a79a19b43fad144183a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f71b969bef877369ba87d32338208470cbef513061c5b6dfb2966b6213d1f10a"
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
