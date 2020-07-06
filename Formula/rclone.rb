class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.52.2.tar.gz"
  sha256 "d85416de69eb4f21a7e1fa6b974677cc84d25c386f1b4e454b5b04c4cf8dbfa4"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f5853b3bac460032f54017dce763393f2e35297653d8ea5533402bf98147cef8" => :catalina
    sha256 "f024d2cd3dd8a06a4d2a2c855ec3a5640c4fe158abab6b9f231eb58b51515ad3" => :mojave
    sha256 "a713fb93e6d02b94b8a8dbe324269836b2f4e5b13ee53aa2acb996646aac3ba8" => :high_sierra
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
