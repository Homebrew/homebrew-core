class Rclone < Formula
  desc "Rsync for cloud storage"
  homepage "https://rclone.org/"
  url "https://github.com/ncw/rclone/archive/v1.38.tar.gz"
  sha256 "d4806a55b64ab54923b55b230f2b2679406d5de995884433d3d60516bb8ebcc0"
  head "https://github.com/ncw/rclone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a56229973977da37d6f76889f40b5358fde722b202d756d3d82c4071a0c0046" => :high_sierra
    sha256 "574ca164ba465c4fda3b122df986be6a6d2ffcbb6f4d538c9dbd7b0bd58cd49e" => :sierra
    sha256 "2e2cfcd9373d8a42b37d26fac848e27dc0b66b36ee2fc020e05a88e628676cdd" => :el_capitan
    sha256 "8188a572f3c70bf9f277e77c2d2ee9fca2b70e55f3c4b19fdeed231bbedaf8a3" => :yosemite
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
