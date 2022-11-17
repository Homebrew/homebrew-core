class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.60.1.tar.gz"
  sha256 "b0037124c04fd1c31a1d9ae1c80e25555da3a22d7ab1ae714ed2c02247fbdac5"
  license "MIT"
  head "https://github.com/rclone/rclone.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf4b831058093b35fdb25c990f1c5fd0287b716e40a1e187fe358bf434565bc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4118be968e8bba34fd4f3e43b6e5837c3c5af7210121e00de600340ff891eda0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6690a32054694755cbe782c502bd420aa6edd6a831e9e90c92331f12bee262c2"
    sha256 cellar: :any_skip_relocation, ventura:        "162c8c2056260539c95ae7d366ef311b42a9a3576015fbad16e92f1074297179"
    sha256 cellar: :any_skip_relocation, monterey:       "e5898867cd70218275fc4155ce6bdb30e997f4d2d0ebad709f4b8533cd853804"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf6b18e1fbe8204b3bfde1803d04fc868d69ee63e572258d4c00db14128decb"
    sha256 cellar: :any_skip_relocation, catalina:       "d2ff9b3dca33dcfb028f75fc49c73a74b7e362544e5bbaa84a13f03c4468068d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64447a1eb8701a3ff640804b0c31a0d133c433b520646d5915649b52ff8cccfe"
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
