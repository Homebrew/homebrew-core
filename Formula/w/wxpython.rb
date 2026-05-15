class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/22/43/81657a6b126ffc19163500a8184d683cec08eb4e1d06905cd0c371c702d0/wxpython-4.2.5.tar.gz"
  sha256 "44e836d1bccd99c38790bb034b6ecf70d9060f6734320560f7c4b0d006144793"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f386143a6e4461fde98aaa60c28f8dc1c87270ad53aaef1fc3b059753ca7d04b"
    sha256 cellar: :any, arm64_sequoia: "101056218733233f473e26ed0836b3c385fc55a8cb6653ab4840241df62c444e"
    sha256 cellar: :any, arm64_sonoma:  "1d8b4b5e2a4548a25fd602ceca03f1d217a508f6160b528c88cabd5da92379ac"
    sha256 cellar: :any, sonoma:        "fb2da74fde2f55b27d36418a776ed1a3a3f884319d406618d022f8e409450ba6"
    sha256               arm64_linux:   "4321aecdd3168f3f2bb0ae102d2f93da7449c0f4968f5c746f18e2e25feabf39"
    sha256               x86_64_linux:  "8b3b5bea2efe6ccac67b575e3d308d9d5688120e9da07693be91c47ff5f6f0c5"
  end

  depends_on "cython" => :build
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
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python)
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
