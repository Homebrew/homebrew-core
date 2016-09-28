class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://files.pythonhosted.org/packages/d6/55/fd4553adc0050b4da3bff9bd0c57bcee3d56da23100b58e2c2570e533ab2/rtv-1.12.1.tar.gz"
  sha256 "784ce662e96c81280d8c6daf67d3ff437c3eedd5ed9825c6b38a0a5677497a86"
  revision 1

  head "https://github.com/michael-lazar/rtv.git"

  bottle do
    sha256 "ad7e6a805a7155af7aeae92de6ff1d813b4951cc053d0ca704433bfac0b959a2" => :sierra
    sha256 "2d100261f851e470d8ae88ab0a9796afe23d324e324748c75d20b7c35e1857d4" => :el_capitan
    sha256 "56f2c2b6e580c6be8eae4cc4eb83fb18481a9ddebabba76a66d0c8512c8100e2" => :yosemite
  end

  depends_on :python3

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/86/ea/8e9fbce5c8405b9614f1fd304f7109d9169a3516a493ce4f7f77c39435b7/beautifulsoup4-4.5.1.tar.gz"
    sha256 "3c9474036afda9136aac6463def733f81017bf9ef3510d25634f335b0c87f5e1"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "kitchen" do
    url "https://files.pythonhosted.org/packages/d7/17/75c460f30b8f964bd5c1ce54e0280ea3ec8830a7c73a35d5036974245b2f/kitchen-1.2.4.tar.gz"
    sha256 "38f73d844532dba7b8cce170e6eb032fc07d0d04a07670e1af754bd4c91dfb3d"
  end

  resource "mailcap-fix" do
    url "https://files.pythonhosted.org/packages/2e/44/79b536cf6659c8a93ac3aa988726c0dbfc84fa35ac40910795ec83dcbe0e/mailcap-fix-0.2.0.tar.gz"
    sha256 "0fc57a701801cd31c45a8f0a661144085b4b0c56b8990c74f9af02af1d0feb60"
  end

  resource "praw" do
    url "https://files.pythonhosted.org/packages/9b/90/2b41c0b374164a9b033093aea7c7f2b392c6333972f83156ab92a3bfbbc4/praw-3.5.0.zip"
    sha256 "0aa3da06d731ed5aa8994f34e46fb36006d168d597ddee216671369917fe8dc3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "update_checker" do
    url "https://files.pythonhosted.org/packages/ae/06/84e8872337ff2c94a417eef571ac727b1cf2c98355462f7ca239d9eba987/update_checker-0.11.tar.gz"
    sha256 "681bc7c26cffd1564eb6f0f3170d975a31c2a9f2224a32f80fe954232b86f173"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/rtv", "--version"
  end
end
