class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.45.tar.gz"
  sha256 "7cfe20990fa88be5a3883e2d8059e67244032a7db46414370643eecb86fe1b58"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "52bad5f914eefe5a247845951b8a85620b853deaa20932188144f8494ce037ab" => :mojave
    sha256 "1fb9962af9e31379ce83c023af0c755923e379bb3ca13fce51d53170fe2ec444" => :high_sierra
    sha256 "f9bc7dd1d0aaaaa06d3b5d0bc1328f8f0d9de0480991d757b595be65c68cf5d4" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
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
