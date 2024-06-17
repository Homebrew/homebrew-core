class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/aa/64/d749e767a8ce7bdc3d533334e03bb1106fc4e4803d16f931fada9007ee13/wxPython-4.2.1.tar.gz"
  sha256 "e48de211a6606bf072ec3fa778771d6b746c00b7f4b970eb58728ddf56d13d5c"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sonoma:   "120938b86adb0a5317edec17ad9b8e9d490ce7988a9b0677c9fdf1f688e7ed59"
    sha256 cellar: :any, arm64_ventura:  "16bec214594988fe4ecc3828eda9c031daee2b5bd17a3d01a101bb6e52f7360b"
    sha256 cellar: :any, arm64_monterey: "89e763016f0d5176f591072d1e13b78c2fa8b86ab5ecf2588a461b435c8f27cb"
    sha256 cellar: :any, sonoma:         "092cddd2dc534cbda892fba573c7b4062679e099b1b85ba18061608d2bcfec76"
    sha256 cellar: :any, ventura:        "7a61784a48ab5d9462492528c3c66b79542a9c319226c9e92bffc64612778584"
    sha256 cellar: :any, monterey:       "370c1dd9ade8b71d481a5ea8bea50babefc8baeba38303fb5232c4d18c783224"
    sha256               x86_64_linux:   "87d2e67b3a6d57d840c286949e73781feba27ba7007055344687b332349322ad"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12"
  depends_on "six"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # Backport fix for doxygen 1.9.7+. Remove in the next release.
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/0b21230ee21e5e5d0212871b96a6d2fefd281038.patch?full_index=1"
    sha256 "befd2a9594a2fa41f926edf412476479f2f311b4088c4738a867c5e7ca6c0f82"
  end

  def python
    "python3.12"
  end

  def install
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
