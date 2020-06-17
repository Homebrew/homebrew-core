class Vfuse < Formula
  desc "Convert bootable DMG images for use in VMware Fusion"
  homepage "https://github.com/chilcote/vfuse"
  url "https://github.com/chilcote/vfuse/archive/3.0.0.tar.gz"
  sha256 "83e4abde8913071d9b65b5238481464130b5ce5f5f0f9bb441f2514115ddd92b"

  bottle :unneeded

  def install
    bin.install Dir["pkgroot/usr/local/vfuse/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfuse --version")
  end
end
