class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.39.tar.gz"
  sha256 "1b87291aef395209dec01084f44790d216fcd0440c5d8a9ac19668704f05ece9"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00ce6a86c1735b9cdc22934cd8a06c24ccd1f07a979dfc0287962eb7acba84d3" => :high_sierra
    sha256 "f65be58ac9e4434eff6d3f9dc4d5f3d0332168e9228207ce973837b650daeb62" => :sierra
    sha256 "849f2a9a623e1ada277e448975cdac3d988dd077c0d5636f3eda999b875e3762" => :el_capitan
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
