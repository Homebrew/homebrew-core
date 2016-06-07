class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language."
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://pypi.python.org/packages/source/x/xdot/xdot-0.6.tar.gz"
  sha256 "c71d82bad0fec696af36af788c2a1dbb5d9975bd70bfbdc14bda15b5c7319e6c"

  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "18110705b33c93b878b20c73b897cde121b4e4e2c054c1af2e0d5c863f16017f" => :el_capitan
    sha256 "d074dd582b0ca17aa565f75a2b53048f97360ac03d53e6fd0edb3f520c8efc06" => :yosemite
    sha256 "6c9a134c44cb444421e29cc398c9c00ca6f8849def89012dce1d69581b41227e" => :mavericks
  end

  depends_on "graphviz"
  depends_on "pygtk"
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
