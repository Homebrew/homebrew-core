class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.org/"
  url "https://files.pythonhosted.org/packages/05/ae/11750b375f48d65de79276b34c8ae663e90700ace388256e0077c8eeb23c/tox-3.1.3.tar.gz"
  sha256 "0a0f1e8e15569e6507597517aa9e890434e8cc604bf229748c877751b4498054"

  bottle do
    cellar :any_skip_relocation
    sha256 "24849c8555155b0e85d9efed4106cc7589f34c30977aa77c4a52a0b67468b817" => :high_sierra
    sha256 "30ee158b8ceeeefa725316d91602a0bd05e28f8e874406585f511164712f6795" => :sierra
    sha256 "5b573142465631e4112bf02f770957c3f6f13c08c49e771d28b440a5880ffcc8" => :el_capitan
  end

  depends_on "python"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
    sha256 "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/83/ef7d976c12d67a5c7a5bc2a47f0501c926cabae9d9fcfdc26d72abc9ba15/pluggy-0.7.1.tar.gz"
    sha256 "95eb8364a4708392bae89035f45341871286a333f749c3141c20573d2b3876e1"
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
