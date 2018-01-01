class StormpathCli < Formula
  include Language::Python::Virtualenv

  desc "The official Stormpath command-line client"
  homepage "https://github.com/stormpath/stormpath-cli"
  url "https://github.com/stormpath/stormpath-cli/archive/0.1.3.tar.gz"
  sha256 "e6ec75f781bc85ed7648c9df60c40d863f4cc2b091a90db6e63b36549fd25dba"
  head "https://github.com/stormpath/stormpath-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3f81f8af021f4891aa86a469f6299697b4d6eb6e0991bd07636ba53180b4c78c" => :high_sierra
    sha256 "ada17bffcfee66020fe7089ec628ddcdc64da1d8121e9a434ff1345066fc40e9" => :sierra
    sha256 "cc6ef08ff24c82dd2cef7b71cb9a6f8bcbcf13e2381e5ef233c8222038db42d6" => :el_capitan
  end

  depends_on "python" if MacOS.version <= :snow_leopard

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/77/ff/9c865275cd19290feba56344eba570e719efb7ca5b34d67ed12b22ebbb0d/cssselect-1.0.1.tar.gz"
    sha256 "73db1c054b9348409e2862fc6c0dde5c4e4fbe4da64c5c5a9e05fbea45744077"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/f4/5b/fe03d46ced80639b7be9285492dc8ce069b841c0cebe5baacdd9b090b164/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/66/45/f11fc376f784c6f2e77ffc7a9d02374ff3ceb07ede8c56f918939409577c/lxml-3.7.2.tar.gz"
    sha256 "59d9176360dbc3919e9d4bfca85c1ca64ab4f4ee00e6f119d7150ba887e3410a"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/db/73/2a73deac557e3d2489e4aa14d606e20d6a445cd24a1f8661a6b1d26b41c6/oauthlib-1.0.3.tar.gz"
    sha256 "ef4bfe4663ca3b97a995860c0173b967ebd98033d02f38c9e1b2cbb6c191d9ad"
  end

  resource "PyDispatcher" do
    url "https://files.pythonhosted.org/packages/cd/37/39aca520918ce1935bea9c356bcbb7ed7e52ad4e31bff9b943dfc8e7115b/PyDispatcher-2.0.5.tar.gz"
    sha256 "5570069e1b1769af1fe481de6dd1d3a388492acddd2cdad7a3bde145615d5caf"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/8f/10/9ce7e91d8ec9d852db6f9f2b076811d9f51ed7b0360602432d95e6ea4feb/PyJWT-1.4.2.tar.gz"
    sha256 "87a831b7a3bfa8351511961469ed0462a769724d4da48a501cb8c96d1e17f570"
  end

  resource "pyquery" do
    url "https://files.pythonhosted.org/packages/dc/37/c2012b88a0ba957b5f27619054eaf21d66b7fd7261d8ade998f1e154eb46/pyquery-1.2.17.tar.gz"
    sha256 "6aa0133b30d9a0229ad65d3a7708c4e853bf46808fb359d06ca56f5039102af6"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stormpath" do
    url "https://files.pythonhosted.org/packages/48/af/208b29a79a3464515ce1f6ca9b3461a8d246cf47c7a530a715b0ee93e269/stormpath-2.5.1.tar.gz"
    sha256 "7f1215c38dfab6c4dee393b54b7394fbdaa3662a31ac0af714481a886657b388"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"stormpath", "--help"
  end
end
