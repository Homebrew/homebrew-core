class Wxpython < Formula
  desc "Python bindings for wxWidgets"
  homepage "https://www.wxpython.org/"
  url "https://files.pythonhosted.org/packages/a4/f5/8c272764770f47fd419cc2eff4c4fa1c0681c71bcc2f3158b3a83d1339ff/wxPython-4.2.2.tar.gz"
  sha256 "5dbcb0650f67fdc2c5965795a255ffaa3d7b09fb149aa8da2d0d9aa44e38e2ba"
  license "LGPL-2.0-or-later" => { with: "WxWindows-exception-3.1" }

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_sequoia: "61df112e56b878d060e4986c1c5f059ea5d4e509388422fb2708ae9987628323"
    sha256 cellar: :any, arm64_sonoma:  "43a633faf4c1e74f172357e23618177bd9ef32692328a0d065183047d336fda2"
    sha256 cellar: :any, arm64_ventura: "0ed00ec4bc814a48811cf50b94f57a0403742a6e2fbce997afa8b211fc5d93bf"
    sha256 cellar: :any, sonoma:        "1a8623673d7ac7aeccbbf323960534cb1abfe7cf6de10398a55e66a2d393d3b8"
    sha256 cellar: :any, ventura:       "3ba5be7b2eccb72980659e9d1f19919a044790076070bc8b7e1c41ac017dcb4d"
    sha256               x86_64_linux:  "c84fcddbb55c6ddc2152b2bae4c8ac70a70a0c11a0e110d30ea800209f0425a9"
  end

  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "sip" => :build
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.13"
  depends_on "six"
  depends_on "wxwidgets"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gtk+3"
  end

  # build patch to build with doxygen 1.11.0+, remove in next release
  # upstream commit ref, https://github.com/wxWidgets/wxWidgets/commit/2d79dfc7a2a8dd42021ff0ea3dcc8ed05f7c23ef
  patch :DATA

  def python
    "python3.13"
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

__END__
diff --git a/ext/wxWidgets/include/wx/datetime.h b/ext/wxWidgets/include/wx/datetime.h
index 6eb2f8c..8c3cf43 100644
--- a/ext/wxWidgets/include/wx/datetime.h
+++ b/ext/wxWidgets/include/wx/datetime.h
@@ -148,7 +148,7 @@ public:
         Local,

         // zones from GMT (= Greenwich Mean Time): they're guaranteed to be
-        // consequent numbers, so writing something like `GMT0 + offset' is
+        // consequent numbers, so writing something like `GMT0 + offset` is
         // safe if abs(offset) <= 12

         // underscore stands for minus
diff --git a/ext/wxWidgets/interface/wx/datetime.h b/ext/wxWidgets/interface/wx/datetime.h
index ae99947..4604b75 100644
--- a/ext/wxWidgets/interface/wx/datetime.h
+++ b/ext/wxWidgets/interface/wx/datetime.h
@@ -96,7 +96,7 @@ public:

         ///@{
         /// zones from GMT (= Greenwich Mean Time): they're guaranteed to be
-        /// consequent numbers, so writing something like `GMT0 + offset' is
+        /// consequent numbers, so writing something like `GMT0 + offset` is
         /// safe if abs(offset) <= 12

         // underscore stands for minus
