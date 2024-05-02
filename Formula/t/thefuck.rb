class Thefuck < Formula
  include Language::Python::Virtualenv

  desc "Programmatically correct mistyped console commands"
  homepage "https://github.com/nvbn/thefuck"
  url "https://files.pythonhosted.org/packages/ac/d0/0c256afd3ba1d05882154d16aa0685018f21c60a6769a496558da7d9d8f1/thefuck-3.32.tar.gz"
  sha256 "976740b9aa536726fa23cadc9a10bf457e92e335901c61fcff9152c84485ac3d"
  license "MIT"
  head "https://github.com/nvbn/thefuck.git", branch: "master"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2500915b3e5ae0e48eaaeb40ec7cf32a9cf9e5a1d5ee122a8b81fee9e2883e9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fce04b72e849bedecb73ab255ce785547c1ca0dc03692fdeb1aff09449088d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c64d432a8a96d9966f3fd83b103b99e74e37e0de3d093470ce49a16262ea27ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "f43208a72c2dd68ae928b83ab412cbb475e5aefe9b187a585e0fee51dad9eb90"
    sha256 cellar: :any_skip_relocation, ventura:        "99bd0b5a6ab2ecced963bf1f671c4d05e01d7ebfc438da2b0cb9b65240b7f1eb"
    sha256 cellar: :any_skip_relocation, monterey:       "99b4d59149650a245c251e1f0451b76f24dcfddead80ab86cc59dc92874487ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca39bcb4d313412aeb25a11fa8d3925bd6d37007b47b27dbc7c0f12508bb2e60"
  end

  depends_on "python@3.12"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
  end

  resource "pyte" do
    url "https://files.pythonhosted.org/packages/ab/ab/b599762933eba04de7dc5b31ae083112a6c9a9db15b01d3109ad797559d9/pyte-0.8.2.tar.gz"
    sha256 "5af970e843fa96a97149d64e170c984721f20e52227a2f57f0a54207f08f083f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  # Drop distutils for 3.12: https://github.com/nvbn/thefuck/pull/1404
  patch do
    url "https://github.com/nvbn/thefuck/commit/dd26fb91a0fdec42fc1990bb91eab21e2c44a0a8.patch?full_index=1"
    sha256 "ea7824d7e4947fb9cd81ed1b5850b53b0e071a82b7e77acaba2391a8bf161b85"
  end

  # Drop imp for 3.12: https://github.com/nvbn/thefuck/commit/0420442e778dd7bc53bdbdb50278eea2c207dc74
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
