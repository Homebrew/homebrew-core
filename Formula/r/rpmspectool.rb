class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/d0/f3/0e45796d8dbacfaf9aa01b914196cf749eff05a7b8cb6ebc6cce57bd0d47/rpmspectool-1.100.0.tar.gz"
  sha256 "4a9eae6169a6ae8a56c6de0985935dad05d3cb087fc5b92f06d9739e215b0327"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "d721a0708e8a4d3fcb3a67d305aa59c25ff2ec6093b295a31cfa728d11bda85c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b3017685ab9100fff47e6ce63a457325320d4e1e34576ba33a35a390ebfebe32"
  end

  depends_on "curl"
  depends_on :linux
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "pycurl" do
    url "https://files.pythonhosted.org/packages/e3/3d/01255f1cde24401f54bb3727d0e5d3396b67fc04964f287d5d473155f176/pycurl-7.45.7.tar.gz"
    sha256 "9d43013002eab2fd6d0dcc671cd1e9149e2fc1c56d5e796fad94d076d6cb69ef"
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
    assert_path_exists testpath/"hello-2.12.1.tar.gz"
  end
end
