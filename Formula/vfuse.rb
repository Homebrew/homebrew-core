class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/2.0.6.tar.gz"
  sha256 "3623d79f284d2a93ccc30d10b863b63ec27687e7afd242d19b8a3b91dbaf0a20"

  bottle :unneeded

  def install
    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
