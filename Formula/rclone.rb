class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/rclone/rclone/archive/v1.53.2.tar.gz"
  sha256 "63c499cef3b216aa657b70ac8217b69f6b1925781d4d8881054194664462d4f1"
  license "MIT"
  head "https://github.com/rclone/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b50cc675b356f43b62f4f5a8acef082a56163ddf1dfdf03a4f360ee6969cdfe" => :catalina
    sha256 "a59703acea34bb4bff3fcd878af83d425a993fc1012b35b7a4210066e6279eab" => :mojave
    sha256 "cea1a5bf6e0346731ba8357e313ae6eb3633e14400c2e9e67bd5a3f8524721f6" => :high_sierra
  end

  deprecate! because: "requires FUSE"

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
