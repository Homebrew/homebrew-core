class Wxpython < Formula
  include Language::Python::Virtualenv

  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/d9/33/b616c7ed4742be6e0d111ca375b41379607dc7cc7ac7ff6aead7a5a0bf53/wxPython-4.2.0.tar.gz"
  sha256 "663cebc4509d7e5d113518865fe274f77f95434c5d57bc386ed58d65ceed86c7"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1cdbafe9c9ffac660ad1a6bcc508c7ad76589a809bea0bcdb17e92c28661ff71"
    sha256 cellar: :any, arm64_monterey: "f9a20a76b190163dac2af2f1813e8e39dd9f637ead5453acdf415c5f2551dc13"
    sha256 cellar: :any, arm64_big_sur:  "6e5b449ee672e78a72d700d78dcf9d11c65eaaa657c9369979dceb7eeb245761"
    sha256 cellar: :any, ventura:        "387be150b988621c79e7866f36a82247617545cc27c78e794b4d18113185749c"
    sha256 cellar: :any, monterey:       "6aef2edb2894f75c23c859edd6db7bd308d6420f4680ce32839b7904b425d382"
    sha256 cellar: :any, big_sur:        "3914f0cc1a1a67431e76c7ca793e5b3bf48ccbf98cb24f9476c8518ea87f3b43"
    sha256 cellar: :any, catalina:       "561959e711b0801d74c68ee2333bd5905e160923ca49a3e2f0dceaf3c80cf534"
    sha256               x86_64_linux:   "a6475f2a2407b5e4bfba19394cb89360cd783b63a9e37eab653989aa18671b6d"
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
