class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language."
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/f5/52/7cec1decf2b07c7749eb997fa5f365781a512722f48e6ad4294e31c94629/xdot-0.7.tar.gz"
  sha256 "d2100c3201d974915d1b89220ce52f380334eb365ab48903573a8135f51d0ee0"

  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "688f1d7c05d6999c1d097b6c2125680a6e808eb0bda06224b845ec7293be0f36" => :sierra
    sha256 "18110705b33c93b878b20c73b897cde121b4e4e2c054c1af2e0d5c863f16017f" => :el_capitan
    sha256 "d074dd582b0ca17aa565f75a2b53048f97360ac03d53e6fd0edb3f520c8efc06" => :yosemite
    sha256 "6c9a134c44cb444421e29cc398c9c00ca6f8849def89012dce1d69581b41227e" => :mavericks
  end

  depends_on "pygobject3"
  depends_on "pygtk"
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
