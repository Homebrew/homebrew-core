class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/d9/33/b616c7ed4742be6e0d111ca375b41379607dc7cc7ac7ff6aead7a5a0bf53/wxPython-4.2.0.tar.gz"
  sha256 "663cebc4509d7e5d113518865fe274f77f95434c5d57bc386ed58d65ceed86c7"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_monterey: "7b558516617be5aa563cf1250276eea3eda660e19bdf8bf66417aa55215992ea"
    sha256 cellar: :any, arm64_big_sur:  "89af5734fee0d433fff77e1cb39f4beaea35fc17518ca0dc99881c892518f0b4"
    sha256 cellar: :any, monterey:       "25ed4d082bf30adc0cdd9652f1866702345ae422d69329e0e3a683522d5a5d9d"
    sha256 cellar: :any, big_sur:        "cf40f9fb59df2b8ea5712b1bf4e1891694c144a010a7b119a6df24f39b46c8a3"
    sha256 cellar: :any, catalina:       "363cff6b220e1d12e1075e3dfbb580eab83c0fea65f3c4f398d2d6eba80c5145"
  end

  depends_on "doxygen" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.10"
  depends_on "six"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # Fix build scripts depending on attrdict3 even though only used on Windows.
  # Remove once upstream PR is merged and in release.
  # PR ref: https://github.com/wxWidgets/Phoenix/pull/2224
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/2e9169effa9abf14f34f8436a791b8829eea7774.patch?full_index=1"
    sha256 "932b3decf8fe5bd982c857796f0b9d936c6a080616733b98ffbd2d3229692e20"
  end

  def install
    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin/"doxygen"
    python = "python3.10"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, *Language::Python.setup_install_args(prefix, python),
                   "--skip-build",
                   "--install-platlib=#{prefix/Language::Python.site_packages(python)}"
  end

  test do
    python = Formula["python@3.10"].opt_bin/"python3.10"
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
