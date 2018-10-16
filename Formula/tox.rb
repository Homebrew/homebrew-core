class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/38/ab/3674069bb1dadcd23e2e76c133cfa806026e68c97510224b3726562a8c44/tox-3.5.2.tar.gz"
  sha256 "4baeb3d8ebdcd9f43afce38aa67d06f1165a87d221d5bb21e8b39a0d4880c134"

  bottle do
    cellar :any_skip_relocation
    sha256 "46cdec66c79c5870c3e65c7e3661a60f7567dca583411e58e67f23dabd49d547" => :mojave
    sha256 "2a627b356bb3986c506afaec5f2ea42ce062b2e947c567c28d8ca4295455caa8" => :high_sierra
    sha256 "e9c4fc4b74993e2d6bbb7d953a7dd6ab9c8aa65b6dc3c2e27dee077dd01fd978" => :sierra
    sha256 "042a9edf97959b862f1534c5b925224bd1b8365685b37a7a4c908a247da80b28" => :el_capitan
  end

  depends_on "python"

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/8d/f0/cf5b0a7fbaab64f48667e48f93a56ce3b746d63da276f5efa97ad5d7d822/filelock-3.0.9.tar.gz"
    sha256 "97694f181bdf58f213cca0a7cb556dc7bf90e2f8eb9aa3151260adac56701afb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/cf/50/1f10d2626df0aa97ce6b62cf6ebe14f605f4e101234f7748b8da4138a8ed/packaging-18.0.tar.gz"
    sha256 "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/65/25/81d0de17cd00f8ca994a4e74e3c4baf7cd25072c0b831dad5c7d9d6138f8/pluggy-0.8.0.tar.gz"
    sha256 "447ba94990e8014ee25ec853339faf7b0fc8050cdc3289d4d71f7f410fb90095"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/c7/fa/eb6dd513d9eb13436e110aaeef9a1703437a8efa466ce6bb2ff1d9217ac7/py-1.7.0.tar.gz"
    sha256 "bf92637198836372b520efcba9e020c330123be8ce527e535d185ed4b6f45694"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/1a/e2/4a7ad8f2808e03caebd3ec0a250b4afbb26d4ba063c39c3286185dd06dd1/pyparsing-2.2.2.tar.gz"
    sha256 "bc6c7146b91af3f567cf6daeaec360bc07d45ffec4cf5353f4d7a208ce7ca30a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094/toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/33/bc/fa0b5347139cd9564f0d44ebd2b147ac97c36b2403943dbee8a25fd74012/virtualenv-16.0.0.tar.gz"
    sha256 "ca07b4c0b54e14a91af9f34d0919790b016923d157afda5efdde55c96718f752"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    pyver = Language::Python.major_minor_version("python3").to_s.delete(".")
    (testpath/"tox.ini").write <<~EOS
      [tox]
      envlist=py#{pyver}
      skipsdist=True

      [testenv]
      deps=pytest
      commands=pytest
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/tox --help")
    system "#{bin}/tox"
    assert_predicate testpath/".tox/py#{pyver}", :exist?
  end
end
