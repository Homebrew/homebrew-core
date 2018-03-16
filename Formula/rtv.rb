class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.22.1.tar.gz"
  sha256 "77c9bbd0e8cd85b6c2daad7b6674d1865f06bfde0a5c2557e12ef1dc1acb2789"
  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4ee9e26cbfec4dc2df263f93b63e7210105f3cae3446aba871690599016d2a4" => :high_sierra
    sha256 "beca032c94767a453dc9ac484591509eb8e9c8c401427750f446755721e3071c" => :sierra
    sha256 "2b984e2ca5c54953f76adae459fbf050e1e12f58b7123f95db5deb2717458e9e" => :el_capitan
  end

  depends_on "python"

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
