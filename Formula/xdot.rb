class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/f5/52/7cec1decf2b07c7749eb997fa5f365781a512722f48e6ad4294e31c94629/xdot-0.7.tar.gz"
  sha256 "d2100c3201d974915d1b89220ce52f380334eb365ab48903573a8135f51d0ee0"
  revision 1

  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1c748698c57c726086ca193b424c46fd62763bb98ead4f5a53adca4fec07f04a" => :high_sierra
    sha256 "4034a49a5d0d730089b5d55755e2d39edd8f17c67a65e9d210adf09b4916239c" => :sierra
    sha256 "4034a49a5d0d730089b5d55755e2d39edd8f17c67a65e9d210adf09b4916239c" => :el_capitan
    sha256 "4034a49a5d0d730089b5d55755e2d39edd8f17c67a65e9d210adf09b4916239c" => :yosemite
  end

  depends_on "pygobject3"
  depends_on "pygtk"
  depends_on "python" if MacOS.version <= :snow_leopard

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
