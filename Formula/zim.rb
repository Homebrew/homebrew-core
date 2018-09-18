class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "http://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.68.tar.gz"
  sha256 "b0bb060d1daf697eb67b76367ce4252202830297792093fd60527b3662ed934b"
  revision 1
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6e51863966a8dfb7a8cfc5d5b3b37d0de8b257ff0de0e5b9f9bd34f647bc88" => :mojave
    sha256 "642d8fc5164980908585d73897eea6130ea6708e2859559e8d9f4df1b4392dee" => :high_sierra
    sha256 "642d8fc5164980908585d73897eea6130ea6708e2859559e8d9f4df1b4392dee" => :sierra
    sha256 "642d8fc5164980908585d73897eea6130ea6708e2859559e8d9f4df1b4392dee" => :el_capitan
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
