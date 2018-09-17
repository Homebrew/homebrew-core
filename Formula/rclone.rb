class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.43.1.tar.gz"
  sha256 "23de9e831487c4c5f1ddd3a5ba6ca72f9d93175b0c4a3bf85f398a2397fc92f5"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e958fcffaefe5b628466b41822a753349b35da88e3e409b45782bdb9a5d6143b" => :mojave
    sha256 "56927f85694056866a399093e88a8bf80f7310ace83febe6dbb0d046e4148436" => :high_sierra
    sha256 "b1538fdecc1cb98b45910e3e1d58d261e560c9a914c26c0950cc9dc5b0889e26" => :sierra
    sha256 "b52d8ea69157c335f2925301ceee55957a149070b1c487f6185387d146d30c01" => :el_capitan
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
