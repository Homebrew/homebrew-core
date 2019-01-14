class Xdot < Formula
  desc "Interactive viewer for graphs written in Graphviz's dot language"
  homepage "https://github.com/jrfonseca/xdot.py"
  url "https://files.pythonhosted.org/packages/75/d3/89151e5c24f59ac5577368651f9d2a5db3cdd870e8f96896e505cb876187/xdot-0.9.tar.gz"
  sha256 "a33701664ecfefe7c7313a120a587e87334f3a566409bc451538fcde5edd6907"
  revision 4
  head "https://github.com/jrfonseca/xdot.py.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "38b81d5431b2acd41aa839acf7866e60deaa87a98fe66e172197535b69447ac9" => :mojave
    sha256 "d6712e41657d53116ad6eb9e18607e937372b2565259f4357d0ee302c9e535cc" => :high_sierra
    sha256 "d6712e41657d53116ad6eb9e18607e937372b2565259f4357d0ee302c9e535cc" => :sierra
  end

  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python"

  resource "graphviz" do
    url "https://files.pythonhosted.org/packages/fa/d1/63b62dee9e55368f60b5ea445e6afb361bb47e692fc27553f3672e16efb8/graphviz-0.8.2.zip"
    sha256 "606741c028acc54b1a065b33045f8c89ee0927ea77273ec409ac988f2c3d1091"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    resource("graphviz").stage do
      system "python3", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/xdot", "--help"
  end
end
