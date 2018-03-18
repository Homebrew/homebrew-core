class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "http://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.68.tar.gz"
  sha256 "b0bb060d1daf697eb67b76367ce4252202830297792093fd60527b3662ed934b"
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55bf8ee68a7174000e0e75064771ce48f21948cf53b9e63e273bdbb9fed60de3" => :high_sierra
    sha256 "55bf8ee68a7174000e0e75064771ce48f21948cf53b9e63e273bdbb9fed60de3" => :sierra
    sha256 "55bf8ee68a7174000e0e75064771ce48f21948cf53b9e63e273bdbb9fed60de3" => :el_capitan
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
