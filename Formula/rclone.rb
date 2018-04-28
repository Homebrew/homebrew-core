class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.41.tar.gz"
  sha256 "4f4cadb4db3a7daff7fa6539eb45273fad5203a0cc9c3a2bd8c2bdb8b349d872"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "afe86985f28727aa86055df345a931604b3c4b91166e1b5d055abaec627f0bd9" => :high_sierra
    sha256 "208dd0c700d3f11aa5c962dc7abd6f3075ce7ffd2dd7b04caf90ba35e70f448f" => :sierra
    sha256 "43637f44353e0e5638ec6a55e34890593c438d6bec81af8363d8284f9a6a3763" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ncw/"
    ln_s buildpath, buildpath/"src/github.com/ncw/rclone"
    system "go", "build", "-o", bin/"rclone"
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
