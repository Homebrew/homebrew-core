class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/0d/b9/723a043cca7407717238e7f5f9fd5df562aa4599204fdb1a76d652ebd281/rpmspectool-1.99.7.tar.gz"
  sha256 "359ab2c743bfe19cde5758e27d798e276aff63e1b9c8bb1bd307e89c07200ed6"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6a3984ff1a7e27b7434158d82a9c424d0413aa1b2d5e31c7418d591aec57e40"
    sha256 cellar: :any_skip_relocation, ventura:       "0bb3455e3b2f5f36ff74f4fbfd74ab0ba3e06905d97ad4add24b0d8cf6130f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2806fc85d5ea031c34610e073d70f601c15433d5c3e4f6beb6abc3c9aeb1fd97"
  end

  depends_on "python@3.11"
  depends_on "rpm"
  uses_from_macos "curl"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/a8/af/24d3acfa76b867dbd8f1166853c18eefc890fc5da03a48672b38ea77ddae/pycurl-7.45.2.tar.gz"
    sha256 "5730590be0271364a5bddd9e245c9cc0fb710c4cbacbdd95264a3122d23224ca"
  end

  def install
    ENV["PYCURL_SSL_LIBRARY"] = "openssl"
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
