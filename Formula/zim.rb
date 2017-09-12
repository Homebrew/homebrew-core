class Zim < Formula
  desc "Graphical text editor used to maintain a collection of wiki pages"
  homepage "http://zim-wiki.org/"
  url "https://github.com/jaap-karssenberg/zim-desktop-wiki/archive/0.67.tar.gz"
  sha256 "6817a4eb7be2326870810e4f4bc57c88128b2087752a8bd54953c95357b919fa"
  head "https://github.com/jaap-karssenberg/zim-desktop-wiki.git"

  depends_on "pkg-config" => :build
  depends_on "gtk+"
  depends_on "python"
  depends_on "pygtk"
  depends_on "pygobject"
  depends_on "pygtksourceview" => :optional
  depends_on "graphviz" => :optional

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec / "lib/python2.7/site-packages"
    system "python", "./setup.py", "install", "--prefix=#{libexec}", "--skip-xdg-cmd"
    bin.install Dir[libexec / "bin/*"]
    bin.env_script_all_files libexec / "bin", :PYTHONPATH => ENV["PYTHONPATH"]
    pkgshare.install "zim"
  end

  test do
    system "#{bin}/zim", "--version"
  end
end
