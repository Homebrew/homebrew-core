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
    rebuild 8
    sha256 cellar: :any, arm64_golden_gate: "144985ca156cce73efc9f6d1a3e60e6ac20d8278b790dc5856316f099a666af1"
    sha256 cellar: :any, arm64_tahoe:       "adcb2e82925f9dc290f910258cb425236e6700b503c2ee7009f5582a423526cc"
    sha256 cellar: :any, arm64_sequoia:     "c23dfeef0c48935eaf313eb30a3d3d1b8da4967573b03e32cba7862147a81c69"
    sha256 cellar: :any, arm64_linux:       "e4488650fd5a142036a4d2ead83f7b9d087e3a15fa69b7dc2ca15679c67a59df"
    sha256 cellar: :any, x86_64_linux:      "6b3143ca1b4d6c4b50b1ba7d49a21cba01114a710b4fe157254d2945f80d67e4"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/eb/9e/1dd8400cb8bb63ee52ae08e4908bc4081bf68f8072e973be5d32d8aa648d/ansicolor-0.3.3.tar.gz"
    sha256 "6de60837fb322b9fb8c8863061504688520bd0aa62defab43dbf4f2c011dafda"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/b1/51/cd61c567092a6cec796144510a68aff158ebfc1df82950a45bae65f28413/chardet-7.6.0.tar.gz"
    sha256 "93d9df6089ded42ed1fe9f57e272c0b74bd0464d45c0c7d50f09f26f31105c3c"
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
