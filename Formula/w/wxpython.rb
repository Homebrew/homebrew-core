class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/4c/d9/4451392d3d6ba45aa23aa77a6f1a9970b43351b956bf61e10fd513a1dc38/wxPython-4.2.3.tar.gz"
  sha256 "20d6e0c927e27ced85643719bd63e9f7fd501df6e9a8aab1489b039897fd7c01"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "38d620143e11e7c4beb27cd0a8cac430d727fdafffac432264cc760653ed1612"
    sha256 cellar: :any, arm64_sequoia: "2507889ef35df2ea5539226cb11ea7036ce898c72d16a42f7acc05a154e5aada"
    sha256 cellar: :any, arm64_sonoma:  "2b421f7072141f279b42af8d63e96fa62fef03f68c1437f7007117aef07c10ae"
    sha256 cellar: :any, arm64_ventura: "533da5d3db0f8ee7650a59368679ff5a5a30aabeb81c04729bd9d19ef024765e"
    sha256 cellar: :any, sonoma:        "a870b3b8197cc1044eaf7d010642fd04d3b322c51e0e26f3214b0b92b26747bf"
    sha256 cellar: :any, ventura:       "6f07c4cc17affc2e9f1c3370218c6d8551b9a0096f799a2cbcc92184403c45d3"
    sha256               arm64_linux:   "457db6b343eeb4be025a86d46c26e6ffc9b79917025ba77ba73bcb43254f5c65"
    sha256               x86_64_linux:  "ffc761ef66d256d59c4711bf5d041ab7cb229d3172ef2bb009e13837cb27ac0a"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "wxwidgets@3.2" # issue ref: https://github.com/wxWidgets/Phoenix/issues/2764

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  def python
    "python3.13"
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
