class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/4c/d9/4451392d3d6ba45aa23aa77a6f1a9970b43351b956bf61e10fd513a1dc38/wxPython-4.2.3.tar.gz"
  sha256 "20d6e0c927e27ced85643719bd63e9f7fd501df6e9a8aab1489b039897fd7c01"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3e47059dc4a8710a730dc27af12a6251244b4a82a0b42957c661c583b7212928"
    sha256 cellar: :any, arm64_sonoma:  "299ffa3f6406ce0dfe2a75b24c61d46cfdabd35bffc7d6effe4e6e634945f88e"
    sha256 cellar: :any, arm64_ventura: "9cbc4877d65c9d55d2161d756a167884d330a69e12f6dbc970119cdf8bd17413"
    sha256 cellar: :any, sonoma:        "c3e8445d7fe4d231909c6462812c02818e2b27aa7079de9dab8b7540e2f36d7b"
    sha256 cellar: :any, ventura:       "27267b1cf5018724f9a91fa7e6aae443da2ce43d11828c7ddc5d302aff97b770"
    sha256               arm64_linux:   "fe385dac180bc47d7ac80b4757daa4a247899cf377677553769944a8cb890e7f"
    sha256               x86_64_linux:  "a0532b1d4ad738222a8e3e39909ce259c048b3977cfbd509f2d131f07a734ed8"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "wxwidgets"

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
