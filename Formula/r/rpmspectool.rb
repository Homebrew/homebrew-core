class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/d0/f3/0e45796d8dbacfaf9aa01b914196cf749eff05a7b8cb6ebc6cce57bd0d47/rpmspectool-1.100.0.tar.gz"
  sha256 "4a9eae6169a6ae8a56c6de0985935dad05d3cb087fc5b92f06d9739e215b0327"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_linux:  "fe5716e5efa6649b4b398c946e14270eec51cd6569c498eb5eae6fe89133d2b5"
    sha256 cellar: :any, x86_64_linux: "e2c290fef89cab141dcfdf5a6f4aa7174e28c13fed6c4242d0088f09b6150a4e"
  end

  depends_on "curl"
  depends_on :linux
  depends_on "openssl@4"
  depends_on "python@3.15"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/fe/62/5851dbbaba9b8ba69019ee74213f1c31b0b2b7ba643ad48e9407638b0dea/pycurl-7.48.0.tar.gz"
    sha256 "b70961a76c412cd34f9cc2c9558e63f89fb37045c59eee396c585b52973be280"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "rpmspectool",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath %_topdir/tmp
    EOS

    (testpath/"hello.spec").write <<~SPEC
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
    SPEC
    system bin/"rpmspectool", "get", testpath/"hello.spec"
    assert_path_exists testpath/"hello-2.12.1.tar.gz"
  end
end
