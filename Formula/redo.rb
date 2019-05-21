class Redo < Formula
  include Language::Python::Virtualenv

  desc "Implements djb's redo: an alternative to make(1)"
  homepage "https://github.com/apenwarr/redo"
  url "https://github.com/apenwarr/redo/archive/redo-0.41.tar.gz"
  sha256 "b7c6411185c58d05bafd0dabeb1f45873bc9bb87f7749705964792fa3fb9fedc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5471cdd4085c91f930069c8a8a315a3847739a79703758c104013ffe97a7618a" => :mojave
    sha256 "b205f9ef95a30c922d62e0deba1be29a0bbbd95d160341261711edaf49e92b82" => :high_sierra
    sha256 "630ac52a05e6b4586f1f78219bc9bce9d17cd67ab1b4acccb3d62256c2839bce" => :sierra
  end

  depends_on "python@2"

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/51/3f/92f9d2f4a1d5da51e7808a469ab40c6cfdf3ba1013f56abb1f46677a655c/Markdown-3.1.tar.gz"
    sha256 "fc4a6f69a656b8d858d7503bda633f4dd63c2d70cf80abdc6eafa64c4ae8c250"
  end

  resource "BeautifulSoup" do
    url "https://files.pythonhosted.org/packages/1e/ee/295988deca1a5a7accd783d0dfe14524867e31abb05b6c0eeceee49c759d/BeautifulSoup-3.2.1.tar.gz"
    sha256 "6a8cb4401111e011b579c8c52a51cdab970041cc543814bbd9577a4529fe1cdb"
  end

  # This patch fixes an issue where redo doesn't work without a controlling
  # terminal. Merged upstream at https://github.com/apenwarr/redo/pull/27 so
  # it's likely to be included in the next release.
  patch do
    url "https://github.com/apenwarr/redo/pull/27.patch?full_index=1"
    sha256 "43459a9c17937d2771ccb7e58756a71911d22c9c160b63e0dd9ee82aa1756ccd"
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
