class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ac/d0/0c256afd3ba1d05882154d16aa0685018f21c60a6769a496558da7d9d8f1/thefuck-3.32.tar.gz"
  sha256 "976740b9aa536726fa23cadc9a10bf457e92e335901c61fcff9152c84485ac3d"
  license "MIT"
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    rebuild 7
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "087a105ef29b07b4e1470d7c412a79f7be311ca6692dba22835e8b2a28ea7397"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b70c9d501ee13654b398e6b1eb386ac26a3513b2352023782f7bad98cc6e83fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06e2af0755eb040bb98ada50165aee62704808689d97bda10f088c1959e47c92"
    sha256 cellar: :any,                 arm64_linux:       "02df15efac00a2d46cebcfe45b622ed181c9b7f81f2ba01de704083b5c20bd44"
    sha256 cellar: :any,                 x86_64_linux:      "1618e26eb097230c0ca1f8fc8003fc16dd1b4bbafc6ded0484466e9e357054ac"
  end

  depends_on "python@3.14"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/ab/ab/b599762933eba04de7dc5b31ae083112a6c9a9db15b01d3109ad797559d9/pyte-0.8.2.tar.gz"
    sha256 "5af970e843fa96a97149d64e170c984721f20e52227a2f57f0a54207f08f083f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  # Drop distutils for 3.12
  patch do
    url "https://github.com/nvbn/thefuck/commit/dd26fb91a0fdec42fc1990bb91eab21e2c44a0a8.patch?full_index=1"
    sha256 "ea7824d7e4947fb9cd81ed1b5850b53b0e071a82b7e77acaba2391a8bf161b85"
    type :unofficial
    resolves "https://github.com/nvbn/thefuck/pull/1404"
  end

  # Drop imp for 3.12: https://github.com/nvbn/thefuck/commit/0420442e778dd7bc53bdbdb50278eea2c207dc74
  # Drop the `setup.py` pip version check using `pkg_resources`, removed in setuptools 82
  # https://github.com/nvbn/thefuck/pull/1555
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      Add the following to your .bash_profile, .bashrc or .zshrc:

        eval $(thefuck --alias)

      For other shells, check https://github.com/nvbn/thefuck/wiki/Shell-aliases
    EOS
  end

  test do
    ENV["THEFUCK_REQUIRE_CONFIRMATION"] = "false"
    ENV["LC_ALL"] = "en_US.UTF-8"

    output = shell_output("#{bin}/thefuck --version 2>&1")
    assert_match "The Fuck #{version} using Python", output

    output = shell_output("#{bin}/thefuck --alias")
    assert_match "TF_ALIAS=fuck", output

    output = shell_output("#{bin}/thefuck echho ok")
    assert_equal "echo ok", output.chomp

    output = shell_output("#{bin}/fuck")
    assert_match "Seems like fuck alias isn't configured!", output
  end
end

__END__
diff --git a/setup.py b/setup.py
--- a/setup.py
+++ b/setup.py
@@ -1,19 +1,9 @@
 #!/usr/bin/env python
 from setuptools import setup, find_packages
-import pkg_resources
 import sys
 import os
 import fastentrypoints
 
-
-try:
-    if int(pkg_resources.get_distribution("pip").version.split('.')[0]) < 6:
-        print('pip older than 6.0 not supported, please upgrade pip with:\n\n'
-              '    pip install -U pip')
-        sys.exit(-1)
-except pkg_resources.DistributionNotFound:
-    pass
-
 if os.environ.get('CONVERT_README'):
     import pypandoc
 
diff --git a/thefuck/conf.py b/thefuck/conf.py
index 27876ef47..611ec84b7 100644
--- a/thefuck/conf.py
+++ b/thefuck/conf.py
@@ -1,4 +1,3 @@
-from imp import load_source
 import os
 import sys
 from warnings import warn
@@ -6,6 +5,17 @@
 from . import const
 from .system import Path

+try:
+    import importlib.util
+
+    def load_source(name, pathname, _file=None):
+        module_spec = importlib.util.spec_from_file_location(name, pathname)
+        module = importlib.util.module_from_spec(module_spec)
+        module_spec.loader.exec_module(module)
+        return module
+except ImportError:
+    from imp import load_source
+

 class Settings(dict):
     def __getattr__(self, item):
diff --git a/thefuck/types.py b/thefuck/types.py
index 96e6ace67..b3b64c35d 100644
--- a/thefuck/types.py
+++ b/thefuck/types.py
@@ -1,9 +1,8 @@
-from imp import load_source
 import os
 import sys
 from . import logs
 from .shells import shell
-from .conf import settings
+from .conf import settings, load_source
 from .const import DEFAULT_PRIORITY, ALL_ENABLED
 from .exceptions import EmptyCommand
 from .utils import get_alias, format_raw_script
