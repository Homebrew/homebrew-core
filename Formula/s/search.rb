class Search < Formula
  include Language::Python::Virtualenv

  desc "A command line tool to search words in files"
  homepage "https://github.com/mark1n0/search"
  url "https://github.com/mark1n0/search/archive/v0.1.tar.gz"
  sha256 "74d52b69157f6dc4d8394f5144e72020b3cca41b89b21f54981d597b487f2199"

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"search", "--version"
  end
end
