class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "http://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.69.tar.gz"
  sha256 "48205c533f1df4d8b143d5bc5adc09a6cd979c53a5d6b504922d8ac28b57e532"
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "40371c83122357897c923c61ce784a8bc14d08ee5cbfa025caca43ce8ff6b515" => :mojave
    sha256 "434beb268dd464539454cf3f523e49628b8b3f6a128ab1a9f1eb9ea373c64fd4" => :high_sierra
    sha256 "434beb268dd464539454cf3f523e49628b8b3f6a128ab1a9f1eb9ea373c64fd4" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "pygobject"
  depends_on "pygtk"
  depends_on "python@2"
  depends_on "graphviz" => :optional
  depends_on "pygtksourceview" => :optional

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
