class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.42.tar.gz"
  sha256 "c98379cf6c91544534b2c76929c13337acc013d5a7015deb01492a63b1339f3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "847db9d0cb26a07a0a65ff478141006ba9f83cc242e99bb4010537015d2f5002" => :mojave
    sha256 "6bb0d9320b7e2b5d0092ee825cd74a3d81175563d8a562af5e3bf941e0828a4a" => :high_sierra
    sha256 "f4088a0ae5895759a6969b5bcbe670c024871b6edba1eccb635f8ef9dcfd82ce" => :sierra
  end

  depends_on "python@2" # does not support Python 3

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/ac/df/0ae25a9fd5bb528fe3c65af7143708160aa3b47970d5272003a1ad5c03c6/Markdown-3.1.1.tar.gz"
    sha256 "2e50876bcdd74517e7b71f3e7a76102050edec255b3983403f1a63e7c8a41e7a"
  end

  resource "BeautifulSoup" do
    url "https://files.pythonhosted.org/packages/1e/ee/295988deca1a5a7accd783d0dfe14524867e31abb05b6c0eeceee49c759d/BeautifulSoup-3.2.1.tar.gz"
    sha256 "6a8cb4401111e011b579c8c52a51cdab970041cc543814bbd9577a4529fe1cdb"
  end

  def install
    venv = virtualenv_create(libexec)
    venv.pip_install resources
    # Set the interpreter so that ./do install can find the pip installed
    # resources.
    open("redo/whichpython", "w") do |file|
      file.puts "#{libexec}/bin/python"
    end
    ENV["DESTDIR"] = ""
    ENV["PREFIX"] = prefix
    system "./do", "install"
    man1.install Dir["docs/*.1"]
  end

  test do
    system "#{bin}/redo", "--version"
  end
end
