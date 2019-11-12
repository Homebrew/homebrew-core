class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/2.2.5.tar.gz"
  sha256 "040997cacacf54d61e98cc7268c1c393c04b51fda3bf80fe3d4191acee9c2bb9"

  bottle :unneeded

  def install
    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
