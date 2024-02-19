class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/7d/cc/53ef9a699df75f3f29f672d0bdf7aae162829e2c98f7b7b5f063fd5d3a46/rpmspectool-1.99.10.tar.gz"
  sha256 "b79d59388ecba5f8b957c722a43a429b5a728435f5ed0992011e9482850e3583"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "121a47cd15dc9959fc3a51f762c9879cd5d14a22fbcd92bdf74ac055219249bf"
  end

  depends_on :linux
  depends_on "python-pycurl"
  depends_on "python@3.12"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/b8/a0/524e0aaabf9bc3dfcfb4da4c61a0469d5cbac31e39dd807a832ea6098c91/argcomplete-3.2.1.tar.gz"
    sha256 "437f67fb9b058da5a090df505ef9be0297c4883993f3f56cb186ff087778cfb4"
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
