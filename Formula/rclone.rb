class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.60.0.tar.gz"
  sha256 "357ee8bb1c1589d9640f1eb87ffeb9dbe8bc7ea6f33f90f56df142515a32f4f2"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9142ff1ec8c6fb61a9d57e59a59732b9ceaf0ee79c0557cd5889fde615d5826e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7512219470980475dad384753b90b8878aa56c2709376ea4355ca8ad654d2a1"
    sha256 cellar: :any_skip_relocation, monterey:       "5eeac976085cc98c8c0ec2455ba2cfd00c44e630dd39f8feab9bef6a7c16185f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ac1a2bfbce19ed64dc1aee7e6487ad6fcd03ffc35dc89140f0c0fff027a7684"
    sha256 cellar: :any_skip_relocation, catalina:       "3670207f4997bfdd0b0a11a791bc7e5708e56d3ef16e11d4697fdac4e058a8d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f3c92190ae4c1cfa9602fc58a3442b4dae12819b5a9de787aeb51dfcec6fa2"
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
