class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/2.2.6.tar.gz"
  sha256 "fbf5f8a1c664b03c7513a70aa05c3fc501a7ebdb53f128f1f05c24395871a314"

  bottle :unneeded

  def install
    # Fix upstream artifact packaging issue
    # remove in the next release
    inreplace "Makefile", "2.2.5", "2.2.6"
    inreplace "pkgroot/usr/local/vfuse/bin/vfuse", "2.2.5", "2.2.6"

    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
