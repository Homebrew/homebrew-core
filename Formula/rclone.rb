class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.56.0.tar.gz"
  sha256 "c8dc7927d3c27e9897398855013c5e4eb31a76ab45dd4aed7bcf5f0121375286"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73362c89243f8415e9a41e06600d8526f3957647a25b939fadea9d4d64a5c14a"
    sha256 cellar: :any_skip_relocation, big_sur:       "77af27ded22554ee61128d8bcb23db9226931cc0c02a7f8f0332f23ba5747cb4"
    sha256 cellar: :any_skip_relocation, catalina:      "4f6bf2e51a4952f4cc83760c1c732a5b0742ab693e977ae88df71f655b9dee7a"
    sha256 cellar: :any_skip_relocation, mojave:        "6d0e42bc013481ed943e5aba83ee3800ee03ef24e8d70102480651b89c201414"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96457593aa03904cae1ebf93e889c18d6669c488666d376645ab9f7b494ae581"
  end

  depends_on "go" => :build

  def install
    args = *std_go_args
    on_macos do
      args += ["-tags", "brew"]
    end
    system "go", "build",
      "-ldflags", "-s -X github.com/rclone/rclone/fs.Version=v#{version}",
      *args
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
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
