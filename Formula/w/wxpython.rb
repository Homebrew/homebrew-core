class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/4c/d9/4451392d3d6ba45aa23aa77a6f1a9970b43351b956bf61e10fd513a1dc38/wxPython-4.2.3.tar.gz"
  sha256 "20d6e0c927e27ced85643719bd63e9f7fd501df6e9a8aab1489b039897fd7c01"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "8a416da81b00e340aedfb70409dd2756892f131e254487fbf9156a71b72f7e53"
    sha256 cellar: :any, arm64_sequoia: "8fa76752837630fc7e483766625cd7d971374cb41cdf28e778f2acd098fb57f8"
    sha256 cellar: :any, arm64_sonoma:  "5be8e6d76dcd20efb79201245869740e05ad04335765c8eca0a7c51b5794f3ab"
    sha256 cellar: :any, sonoma:        "fc5a08d8e273c66763ba05448229a20ce65f5c514cf8fa59a5c2c9c8366c008b"
    sha256               arm64_linux:   "6c49edde10b7f4471fa1396045a114d68e084b9f9e64c2af4aef2439bccf47de"
    sha256               x86_64_linux:  "d9dece9868196fa78b4270172e955c87b04fa856ec02ede6bcfb1868e95cdb7b"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "wxwidgets@3.2" # issue ref: https://github.com/wxWidgets/Phoenix/issues/2764

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  def python
    "python3.14"
  end

  def install
    # Avoid requests build dependency which is used to download pre-builts
    inreplace "build.py", /^(import|from) requests/, "#\\0"

    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.cxx11
    ENV["DOXYGEN"] = Formula["doxygen"].opt_bin/"doxygen"
    system python, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end
