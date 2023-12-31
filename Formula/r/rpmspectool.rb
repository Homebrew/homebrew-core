class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/f9/45/d7c3f5ea8f924ec63f4be1bbef072c015dc79e80ce47a488267fa81ba364/rpmspectool-1.99.9.tar.gz"
  sha256 "4452f49d86317d91767ccf0aa5a2f146fbae17574780fc3cb6cd3b651daf295b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c0e42332bbcadd0d09d3a8356ada8aa5d91f18ab4c52f028c5c730cf585fd09f"
  end

  depends_on :linux
  depends_on "python-pycurl"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/85/b9/e2bef848f79fce1e70d048b4de873424fde918c54ac2e6b8638cca887243/argcomplete-2.1.2.tar.gz"
    sha256 "fc82ef070c607b1559b5c720529d63b54d9dcf2dcfc2632b10e6372314a34457"
  end

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
