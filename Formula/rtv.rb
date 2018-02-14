class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.21.0.tar.gz"
  sha256 "7e6a8de7b3e05b93d135cd2aa869b3d20f6ec26073a586e3595cff7f2df1aafa"
  revision 1
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9ee98d9223e0410254b749751c2a175b900e133e5c029c5ae74ae36b1d7ce0f" => :high_sierra
    sha256 "cb33c61261304d00d606f9666071234f8c8227a4fc7750c94864ac395322ab74" => :sierra
    sha256 "fb36bbf09f27ca20d22cbdac955363333a5a67bca625237a5049e366091cd732" => :el_capitan
  end

  depends_on "python3"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
