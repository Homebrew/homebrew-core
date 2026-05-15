class Vint < Formula
  include Language::Python::Virtualenv

  desc "Vim script Language Lint"
  homepage "https://github.com/Vimjas/vint"
  url "https://files.pythonhosted.org/packages/9c/c7/d5fbe5f778edee83cba3aea8cc3308db327e4c161e0656e861b9cc2cb859/vim-vint-0.3.21.tar.gz"
  sha256 "5dc59b2e5c2a746c88f5f51f3fafea3d639c6b0fdbb116bb74af27bf1c820d97"
  license "MIT"
  revision 2
  head "https://github.com/Vimjas/vint.git", branch: "master"

  bottle do
    rebuild 7
    sha256 cellar: :any,                 arm64_tahoe:   "253fc8481dee8ad20013ec07a09d1de0857b361f4ea4b9109e1d042720be995a"
    sha256 cellar: :any,                 arm64_sequoia: "162fc8f95662794610623e833c5dc3b8a8b4061b96e051ece9df831c35b6857f"
    sha256 cellar: :any,                 arm64_sonoma:  "03f615049167d33b5ab100cbbaff0d4461503392d550b895c98438ba5e5855e4"
    sha256 cellar: :any,                 sonoma:        "0f54ebab62e360237f7dbb53db433dbf7270a94a57f63f6fbca5b7ce4dc06618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627fcee4eb35a20a7af92b2e52e4dd278ce997a1107406cfc45fb07aefa4bc21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a203916188f247d771f950c352eb7d70c5483651a612e2366ff9804da26b00c2"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/79/74/630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6ac/ansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  # Drop setuptools dep. Next release will switch to setuptools_scm,
  # this patch uses importlib for a smaller self-contained diff
  # https://github.com/Vimjas/vint/commit/997677ae688fbaf47da426500cc56aae7305d243
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vint", "--help"
    (testpath/"bad.vim").write <<~VIM
      not vimscript
    VIM
    assert_match "E492", shell_output("#{bin}/vint bad.vim", 1)

    (testpath/"good.vim").write <<~VIM
      " minimal vimrc
      syntax on
      set backspace=indent,eol,start
      filetype plugin indent on
    VIM
    assert_empty shell_output("#{bin}/vint good.vim")
  end
end

__END__
diff --git a/vint/linting/cli.py b/vint/linting/cli.py
index 55db52e..c347f23 100644
--- a/vint/linting/cli.py
+++ b/vint/linting/cli.py
@@ -1,7 +1,6 @@
 import sys
 from argparse import ArgumentParser
 from pathlib import PosixPath
-import pkg_resources
 import logging

 from vint.linting.linter import Linter
@@ -150,11 +149,11 @@ class CLI(object):


     def _get_version(self):
-        # In unit tests, pkg_resources cannot find vim-vint.
-        # So, I decided to return dummy version
+        from importlib import metadata
+
         try:
-            version = pkg_resources.require('vim-vint')[0].version
-        except pkg_resources.DistributionNotFound:
+            version = metadata.version('vim-vint')
+        except metadata.PackageNotFoundError:
             version = 'test_mode'

         return version
