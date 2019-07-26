class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.42.tar.gz"
  sha256 "c98379cf6c91544534b2c76929c13337acc013d5a7015deb01492a63b1339f3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "532a64d89cc11baddad9a66e1189e04fdf0492a6b9c20e0af29e19276b8d7f32" => :mojave
    sha256 "e880f5d183e42b05c78a4d6aa6e273cad1a89df0d7d34a71774b04c39b3f6a6c" => :high_sierra
    sha256 "7705a8883c4d314aab6369a57336729274211b7bd7bd4707bde7b3776f880ef3" => :sierra
  end

  depends_on "python@2"

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
