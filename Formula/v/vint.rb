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
    rebuild 6
    sha256 cellar: :any,                 arm64_sequoia: "d2e44d7c8f741058e7053452b35c8c95997f96f60bfb3b2327194a5bed7d90de"
    sha256 cellar: :any,                 arm64_sonoma:  "4761ec8bf7182df8ae684701d235309968cc96197f6fa6faa876e4ac6b9af816"
    sha256 cellar: :any,                 arm64_ventura: "e5bc6e57ded07e6f471eec105c4257f76939e2cb1f6efb4ec428bac68aac9e7b"
    sha256 cellar: :any,                 sonoma:        "b768c5d123e23695279516cc24c2bd6de3b2a31bf8d9c25e2f9b252a6ce045b4"
    sha256 cellar: :any,                 ventura:       "c3d75f055b30da8429d0506965e1770baa6dfa8eed9c6b371125e20bfc1296e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16adbea12b2c4447bc977212aec4286b94b7a1b16afdadb780efcab233a862f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e353a7a8aef81e094ecdc67dece6c35786b9cf38c263b3f600a190166a07bebd"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "ansicolor" do
    url "https://files.pythonhosted.org/packages/79/74/630817c7eb1289a1412fcc4faeca74a69760d9c9b0db94fc09c91978a6ac/ansicolor-0.3.2.tar.gz"
    sha256 "3b840a6b1184b5f1568635b1adab28147947522707d41ceba02d5ed0a0877279"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
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
