class UnionfsFuse < Formula
  desc "FUSE based union filesystem with COW"
  homepage "https://github.com/rpodgorny/unionfs-fuse"
  url "https://github.com/rpodgorny/unionfs-fuse/archive/v2.1.tar.gz"
  sha256 "c705072a33a18cbc73ffe799331d43410b6deef5d6f2042038f8fd3ab17b6e2e"
  head "https://github.com/rpodgorny/unionfs-fuse.git"

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    system "make"
    bin.install "src/unionfs"
    bin.install "src/unionfsctl"
    sbin.install "mount.unionfs"
    man8.install "man/unionfs.8"
  end

  test do
    system "#{bin}/unionfs", "-V"
  end
end
