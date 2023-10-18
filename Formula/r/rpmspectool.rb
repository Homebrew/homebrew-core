class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/0d/b9/723a043cca7407717238e7f5f9fd5df562aa4599204fdb1a76d652ebd281/rpmspectool-1.99.7.tar.gz"
  sha256 "359ab2c743bfe19cde5758e27d798e276aff63e1b9c8bb1bd307e89c07200ed6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, x86_64_linux: "2a399ded29cfacb69f065d2b7c17270eceb26331809bf89029d65d1d6fef24e4"
  end

  depends_on :linux
  depends_on "python-argcomplete"
  depends_on "python-pycurl"
  depends_on "python@3.11"
  depends_on "rpm"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath %_topdir/tmp
    EOS

    (testpath/"hello.spec").write <<~EOS
      Name:           hello
      Version:        2.12.1
      Release:        1
      Summary:        Prints a familiar, friendly greeting
      License:        GPL-3.0-or-later AND GFDL-1.3-or-later
      URL:            https://www.gnu.org/software/hello/
      Source0:        https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz

      %description
      The GNU Hello program produces a familiar, friendly greeting.
      Yes, this is another implementation of the classic program that
      prints “Hello, world!” when you run it.

      %prep
      %setup -q

      %build
      %configure
      %make_build

      %install
      %make_install
      rm -f $RPM_BUILD_ROOT/%_infodir/dir
      %find_lang hello

      %files -f hello.lang
      %license COPYING
      %_mandir/man1/hello.1*
      %_bindir/hello
      %_infodir/hello.info*
    EOS
    system bin/"rpmspectool", "get", testpath/"hello.spec"
    assert_predicate testpath/"hello-2.12.1.tar.gz", :exist?
  end
end
