class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/2.2.2.tar.gz"
  sha256 "5ed949e1161d69808ccaac8f7427c8021ebe8e54cf15d680d32d13c7fb2a751d"

  bottle :unneeded

  def install
    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
