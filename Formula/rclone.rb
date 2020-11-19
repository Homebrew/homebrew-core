class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.3.tar.gz"
  sha256 "46fb317057ada21add1fa683a004e1ad5b2a1523c381f59b40ed1b18f2856ad0"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4346e37a24fad485a91e2a5ac7a083cd191f64cbe5ec220f51ed019127329e87" => :big_sur
    sha256 "9591cd57d0491adf64e65218b87f123ffcb46ccc1281baf53c35f773080805a2" => :catalina
    sha256 "acc6f0a73e589b51f82b7e0bb4ec8d09e36b020031ff59ed8a2e99956c64cd19" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "brew", *std_go_args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  def caveats
    <<~EOS
      Homebrew's installation does not include the `mount` subcommand.
    EOS
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
