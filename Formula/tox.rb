class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/f6/e2/80f14b1d9af8f940d368e90abd66de7e84659a76a6693bd74cc923c7d840/tox-3.1.0.tar.gz"
  sha256 "de70c2ab27aa4c4af5534261db7d52f9e52e2a9f2d4061eb99eefb0beb52a32b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f3011bfafe9ef18b1f52e26e5212379a3ce62cde43e06eb73f16659704dc2686" => :high_sierra
    sha256 "1253dcfb9018f067f46b9e19537468d101afd3287acc17132d3a875da1fa462b" => :sierra
    sha256 "2d25b952d26693cdc81574a5b98386f8dfa642723a27426895f00581ae00292e" => :el_capitan
  end

  depends_on "python"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
    sha256 "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/11/bf/cbeb8cdfaffa9f2ea154a30ae31a9d04a1209312e2919138b4171a1f8199/pluggy-0.6.0.tar.gz"
    sha256 "7f8ae7f5bdf75671a718d2daf0a64b7885f74510bcd98b1a0bb420eb9a9d0cff"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/35/77/a0a2a4126cf454e6ac772942898379e2fe78f2b7885df0461a5b8f8a8040/py-1.5.4.tar.gz"
    sha256 "3fd59af7435864e1a243790d322d763925431213b6b8529c6ca71081ace3bbf7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
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
