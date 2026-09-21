class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/3d/dd/026f6286f8beefcdd9551ad2e05b4e3edb45e638cdc067db211c53c950ce/wxpython-4.3.1.tar.gz"
  sha256 "4e3a95b63175be8e10f0662de506a36d8cc6cb86ecc5b30ae880c8dafb34a0cd"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "42cf8d7e22cec85f55b84174ee2723cc65e7956b02b08bb8a4a598eb097fc55c"
    sha256 cellar: :any, arm64_tahoe:       "66ac33f5a89ba70e1a6cb03ae0422b8786890f8a8787370cd18292f8478fe22a"
    sha256 cellar: :any, arm64_sequoia:     "dfb56521e5517fcba91c12998ad51bd1813593ebad26c99e777a2e1a7b9583c3"
    sha256 cellar: :any, arm64_sonoma:      "8b1c9858421864fcf9769acc215e7593fe00446f923bc92a1fde856301f9d7c1"
    sha256               arm64_linux:       "a60df642704715f5ee81b2c3f6a58fe559c3e7c7ebe472284a84a1be81090a54"
    sha256               x86_64_linux:      "5c6fdfff151ebdcc651b1005f956d3c6231a38261033c42ce44e2da37244295b"
  end

  depends_on "cython" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.14"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "gtk+3"
  end

  pypi_packages exclude_packages: %w[numpy pillow]

  # Upstream pins Doxygen 1.9.1, which keeps `constexpr` in the XML type; ours is newer
  # and reports it as an attribute, so `constexpr` members get a setter and fail to build.
  patch :DATA

  # Fix Doxygen binding generation, upstream PR ref, https://github.com/wxWidgets/Phoenix/pull/2963
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/911bd596087a4be61aa1da6654e2e4410f30a461.patch?full_index=1"
    sha256 "90c3c3273efdc7d5f9239e2b3f462ca7e9b564fc62ac0311dfa603f909a1122c"
    type :unofficial
  end

  # Declare the SIP ABI requirement, upstream PR ref, https://github.com/wxWidgets/Phoenix/pull/2964
  patch do
    url "https://github.com/wxWidgets/Phoenix/commit/169e00e00824bb68af6b66b951f7dc082ffe9c7f.patch?full_index=1"
    sha256 "864eebaef96a87cb6ff5cc911a550b08e7795ebfc0d1de763750e6af6338b57e"
    type :unofficial
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python3)
    ENV.cxx11
    ENV["DOXYGEN"] = formula_opt_bin("doxygen")/"doxygen"
    system python3, "-u", "build.py", "dox", "touch", "etg", "sip", "build_py",
                   "--release",
                   "--use_syswx",
                   "--prefix=#{prefix}",
                   "--jobs=#{ENV.make_jobs}",
                   "--verbose",
                   "--nodoc"
    system python3, "-m", "pip", "install", "--config-settings=--build-option=--skip-build", *std_pip_args, "."
  end

  test do
    output = shell_output("#{python3} -c 'import wx ; print(wx.__version__)'")
    assert_match version.to_s, output
  end
end

__END__
diff --git a/etgtools/extractors.py b/etgtools/extractors.py
index 5c3b1d4..b6e9b2d 100644
--- a/etgtools/extractors.py
+++ b/etgtools/extractors.py
@@ -222,6 +222,8 @@ class VariableDef(BaseDef):
     def extract(self, element):
         super(VariableDef, self).extract(element)
         self.type = flattenNode(element.find('type'))
+        if element.get('constexpr') == 'yes' and not self.type.startswith('const'):
+            self.type = 'const ' + self.type
         self.definition = element.find('definition').text
         self.argsString = element.find('argsstring').text
 
