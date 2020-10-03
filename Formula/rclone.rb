class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.1.tar.gz"
  sha256 "b606ebb82bf76cf7e050aaa7bfcc1a688783ec5a4c71a6c3df6aa2f73fe6c8c1"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a13a3b47ceed7b689cd31377fca73e9b4376816243d6be7f50915e9595a514b0" => :catalina
    sha256 "92ccf24f7c26d360c618cb4fb5f4e6ad88880952ea5cdc1ddb232cf9b4d5e60e" => :mojave
    sha256 "97635b69d5ab01055e3dd77b8434889d607ca64016d6faed4a9f0fb24299e7ee" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-tags", "cmount", *std_go_args
    man1.install "rclone.1"
    system bin/"rclone", "genautocomplete", "bash", "rclone.bash"
    system bin/"rclone", "genautocomplete", "zsh", "_rclone"
    bash_completion.install "rclone.bash" => "rclone"
    zsh_completion.install "_rclone"
  end

  test do
    (testpath/"file1.txt").write "Test!"
    system "#{bin}/rclone", "copy", testpath/"file1.txt", testpath/"dist"
    assert_match File.read(testpath/"file1.txt"), File.read(testpath/"dist/file1.txt")
  end
end
