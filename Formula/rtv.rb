class Rtv < Formula
  include Language::Python::Virtualenv

  desc "Command-line Reddit client"
  homepage "https://github.com/michael-lazar/rtv"
  url "https://github.com/michael-lazar/rtv/archive/v1.11.0.tar.gz"
  sha256 "3e2a486719acec838d49a8979f1422f50b37ac3381ac89547dbb41792eeea67d"

  bottle do
    sha256 "3791f86d9613980c8fea5a2fac5867648b14f51af76b88039bde1af9f23807b0" => :el_capitan
    sha256 "2fb9c97763c7f7569b1130a667e5c2fe6e41e08312fb86f02b7cad1180ded74e" => :yosemite
    sha256 "cd6dbf42ad1abe58f022fed06030d6c116c3403ef8d9d53927190d7883e02e52" => :mavericks
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
    url "https://files.pythonhosted.org/packages/8c/2a/db1c970c05e65dd8e0ab76d2d3efa3a4b86417d16bc60efc8d8ce075835f/mailcap-fix-0.1.3.tar.gz"
    sha256 "13b33059db4f3d5cd76ed173fb892dd59625075d6ec528e896840db39fb3b436"
  end

  resource "praw" do
    url "https://files.pythonhosted.org/packages/9b/90/2b41c0b374164a9b033093aea7c7f2b392c6333972f83156ab92a3bfbbc4/praw-3.5.0.zip"
    sha256 "0aa3da06d731ed5aa8994f34e46fb36006d168d597ddee216671369917fe8dc3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/8d/66/649f861f980c0a168dd4cccc4dd0ed8fa5bd6c1bed3bea9a286434632771/requests-2.11.0.tar.gz"
    sha256 "b2ff053e93ef11ea08b0e596a1618487c4e4c5f1006d7a1706e3671c57dea385"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/96/5d/ff472313e8f337d5acda5d56e6ea79a43583cc8771b34c85a1f458e197c3/tornado-4.4.1.tar.gz"
    sha256 "371d0cf3d56c47accc66116a77ad558d76eebaa8458a6b677af71ca606522146"
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
