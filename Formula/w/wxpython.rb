class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/3d/dd/026f6286f8beefcdd9551ad2e05b4e3edb45e638cdc067db211c53c950ce/wxpython-4.3.1.tar.gz"
  sha256 "4e3a95b63175be8e10f0662de506a36d8cc6cb86ecc5b30ae880c8dafb34a0cd"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5959abf9051bc6e3b58611bbbb2a9661180fd629b3208be9f7eb027dfbba7084"
    sha256 cellar: :any, arm64_sequoia: "49736a27d51fe1746a6a48a23afcc0e5856f84a8eaeba51c255d471ba6214b4b"
    sha256 cellar: :any, arm64_sonoma:  "d8ae9530fb20c86e77773dba1beb7887600f37603a5ae92be293d4b4916b42b3"
    sha256 cellar: :any, sonoma:        "bfbb387d2f21f1cb4f5e589ca73e040914c04be752ca204870e015d3ea41e6fc"
    sha256               arm64_linux:   "9a4c43dfef170d50b1e3f4679264d7a9f485ebee5f946ed5f463993bd8b7180a"
    sha256               x86_64_linux:  "8ad63c8a655e368e6daeb8c26dceab15fe739b43e7042755b0d663485b5ccd84"
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

  def python
    "python3.14"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    ENV["WX_CONFIG"] = wx_config.to_s

    ENV.append_path "PYTHONPATH", formula_opt_libexec("cython")/Language::Python.site_packages(python)
    ENV.cxx11
    ENV["DOXYGEN"] = formula_opt_bin("doxygen")/"doxygen"
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
 
