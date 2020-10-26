class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.2.tar.gz"
  sha256 "63c499cef3b216aa657b70ac8217b69f6b1925781d4d8881054194664462d4f1"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3c9040c1cb227bcd2c42681b51e08477a399fe012abf5721a9821d863bc722ac" => :catalina
    sha256 "4a5c527e176a804b81ed291f3dec0ea43b03ffe14f86f4aff8f91d72c53c4c2d" => :mojave
    sha256 "2aa23e60997424d9051c70c7f13ae83ed4b58d1d95eaf511323698b4b0add17f" => :high_sierra
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
