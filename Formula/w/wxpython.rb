class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/22/43/81657a6b126ffc19163500a8184d683cec08eb4e1d06905cd0c371c702d0/wxpython-4.2.5.tar.gz"
  sha256 "44e836d1bccd99c38790bb034b6ecf70d9060f6734320560f7c4b0d006144793"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "748deaf966fa0d91413a15a63122699e8b6143d5afa4cead127b4ebe461b2e0f"
    sha256 cellar: :any, arm64_sequoia: "bd135b2094967cd6dedf1bc6fc9dafb3fcb5c29fdb02542915b421ab13a3743c"
    sha256 cellar: :any, arm64_sonoma:  "cfdfed0cf2d4026791afb1c3d509b5987177fdab04b8e6a8bcf1a885db6d18e3"
    sha256 cellar: :any, sonoma:        "552da2bec28a9636958f80d730bc239faa8617bb49c2b85c33fee77fbc0d116c"
    sha256               arm64_linux:   "4c6204f632286507c17fba2f191153b8d6618709b90dfb3d7f424ad92d913afc"
    sha256               x86_64_linux:  "6ff819ffb1d79f97081cad6c3b30d8bf9286572af749166417935d010677dd4b"
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
