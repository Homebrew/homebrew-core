class Shrinkx < Formula
  include Language::Python::Virtualenv

  desc "Shrinkx is a Python-based tool for effortlessly compressing media files."
  homepage "https://github.com/stormedx/shrinkx"
  url "https://github.com/stormedx/shrinkx/archive/refs/tags/shrinkx.tar.gz"
  version "1.1"
  sha256 "e2d22b9031fb434dd8b37f32f511ad988129b21a40c97fcb7fd5d7d00bb3b2ea"

  depends_on "ffmpeg"
  depends_on "python@3.9"
  
  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/shrinkx", "--version"
  end
end
