class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/d9/33/b616c7ed4742be6e0d111ca375b41379607dc7cc7ac7ff6aead7a5a0bf53/wxPython-4.2.0.tar.gz"
  sha256 "663cebc4509d7e5d113518865fe274f77f95434c5d57bc386ed58d65ceed86c7"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "9cf04be9fe96667a6243e0b6e0b9c34f1f15e86f83e817bd7d3d7dbec997e9b5"
    sha256 cellar: :any, arm64_monterey: "1999911bf51dd73f60c0adc99a3278fa573152a1535de68ef9553cc478ee5a66"
    sha256 cellar: :any, arm64_big_sur:  "fc912d301dc9e189cb9415d0401213e23ce43752dbe1eef499a02cd4154e3334"
    sha256 cellar: :any, ventura:        "4f8b6ad5e9a3645c207d07b2c8b67fba06cc830932a8503c9cfefc76120ddd28"
    sha256 cellar: :any, monterey:       "2fa4ada01a2f338678543fbac2f1acd148b257aa84a9735914f27d9a8a4fea7b"
    sha256 cellar: :any, big_sur:        "981eb95dcd1bc38c7f2a1999858c729b9ceef686f3e066c234bb11312640b115"
    sha256               x86_64_linux:   "5e3bfb9bd3e427fbd65d5b0e565aa7ee6f31c2eab1e3447a0c4b813b664a3d7a"
  end

  depends_on "doxygen" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.11"
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
    python = "python3.11"
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
    python = Formula["python@3.11"].opt_bin/"python3.11"
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
