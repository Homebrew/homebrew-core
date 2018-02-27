class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "http://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.67.tar.gz"
  sha256 "6817a4eb7be2326870810e4f4bc57c88128b2087752a8bd54953c95357b919fa"
  revision 1
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5dc68b594b596da2cf0cf41b4d551dc47a576634ab0274840011ee003385a1c0" => :high_sierra
    sha256 "9f1b73f91e1c0f397ded0c88ec443074b1b2060ddacafa0526f63b908c0eb7da" => :sierra
    sha256 "9f1b73f91e1c0f397ded0c88ec443074b1b2060ddacafa0526f63b908c0eb7da" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "python@2"
  depends_on "pygtk"
  depends_on "pygobject"
  depends_on "pygtksourceview" => :optional
  depends_on "graphviz" => :optional

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/source/p/pyxdg/pyxdg-0.25.tar.gz"
    sha256 "81e883e0b9517d624e8b0499eb267b82a815c0b7146d5269f364988ae031279d"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    resource("pyxdg").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end
    ENV["XDG_DATA_DIRS"] = libexec/"share"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", "./setup.py", "install", "--prefix=#{libexec}", "--skip-xdg-cmd"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"], :XDG_DATA_DIRS => libexec/"share"
    pkgshare.install "zim"
  end

  test do
    system "#{bin}/zim", "--version"
  end
end
