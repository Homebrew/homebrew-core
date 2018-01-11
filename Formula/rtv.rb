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
    sha256 "7223fd4de450947b9edb52a6044e1590de761a997ce1aa47a6f4f6fc1ebc620b" => :high_sierra
    sha256 "6cbc912885fcafb5cac81b93bce61675e47ab87077cb798d0ea9f6acc97fdb9f" => :sierra
    sha256 "15ecb1f561d0eb5eb8f009d5fda5625e22a5667cb559d1aea9ba307cce363441" => :el_capitan
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
