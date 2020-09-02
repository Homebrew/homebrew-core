class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.0.tar.gz"
  sha256 "8dda3015e2230bc6bc768b0ef85069022d69b6863bcbae15f3949782587cf92f"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae392245869cf46c328a5e1947d93e5e7edb93b7e29cf466d560a0532dbf4891" => :catalina
    sha256 "5d00a1da9b94ef0d0418ad20d48a601e7a46e17ef9bae5df14d256d2a59d906b" => :mojave
    sha256 "d90cc67223debdb47bf00ba686c74b24ebac1ea9e4bc12636977d4eb0d57ae7b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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
