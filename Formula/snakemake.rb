class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/af/c2/5ba2d0c9b721e1184ef36c43996830bad81089a3e7c6ae1cfb632ee84902/snakemake-5.8.1.tar.gz"
  sha256 "60c1d11d3a63397b6d91ef394639cb454d9965217747b60fafb5573a498838e4"
  head "https://bitbucket.org/snakemake/snakemake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49f8f204be929b5c6fe3d80bf23b7bcd57044f1c4be6ed8e537712a072317a39" => :catalina
    sha256 "73f3d74fa3ccbe05b0be3c0570075c3b7fd65d155893da372d3c2d7ac8cfd21c" => :mojave
    sha256 "3339c11454a70b26f516327c866b0d472ab6d737331b3c9e5dcb3a24f43d718d" => :high_sierra
  end

  depends_on "python"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/9d214a5af07debc6acf7f3f257265618f1db242a3f8e49a9b516f24523a6/certifi-2019.11.28.tar.gz"
    sha256 "25b64c7da4cd7479594d035c08c2d809eb4aab3a26e5a990ea98cc450c320f1f"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/ee/e2/d392af39dfe241e9fa5e9830ea1f00c077c7ae1dd6ede97cba06404c66fb/ConfigArgParse-0.15.2.tar.gz"
    sha256 "558738aff623d6667aa5b85df6093ad3828867de8a82b66a6d458fb42567beb3"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/f5/a2/49d6db3af61eb139fb8fa2cdff90a4789e8255d227baf8f9a1ec945b4aac/datrie-0.8.tar.gz"
    sha256 "bdd5da6ba6a97e7cd96eef2e7441c8d2ef890d04ba42694a41c7dffa3aca680c"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/c5/62/ed7205331e8d7cc377e2512cb32f8f8f075c0defce767551d0a76e102ce2/gitdb2-2.0.6.tar.gz"
    sha256 "1b6df1433567a51a4a9c1a5a0de977aa351a405cc56d7d35f3388bad1f630350"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/d2/e8/0bd80cc9e1422f5449d663479459c3c032ff7acaf6609a63324d23bde9ac/GitPython-3.0.5.tar.gz"
    sha256 "9c2398ffc3dcb3c40b27324b316f08a4f93ad646d5a6328cafbb871aa79f5e42"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/cb/bb/7a935a48bf751af244090a7bd558769942cf13a7eba874b8b25538f3db01/importlib_metadata-1.3.0.tar.gz"
    sha256 "073a852570f92da5f744a3472af1b61e28e9f78ccf0c9117658dc32b15de7b45"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/69/11/a69e2a3c01b324a77d3a7c0570faa372e8448b666300c4117a516f8b1212/jsonschema-3.2.0.tar.gz"
    sha256 "c8a85b28d377cc7737e46e2d9f2b4f44ee3c0e1deac6bf46ddefc7187d30797a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/4e/b2/e9e512cccde6c54bf66a8e5820a2af779eb8235028627002ca90d4f75bea/more-itertools-8.0.2.tar.gz"
    sha256 "b84b238cce0d9adad5ed87e745778d20a3f8487d0f0cb8b8a586816c7496458d"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/73/93/4f8213fbe66fc20cb904f35e6e04e20b47b85bee39845cc66a0bcf5ccdcb/psutil-5.6.7.tar.gz"
    sha256 "ffad8eb2ac614518bbe3c0b8eb9dffdb3a8d2e3a7d5da51c5b974fb723a5c5aa"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/6c/6f/c1a2e8da80a0029f6b618d7e20e1a6f2a61dd04e2e54225309c2cc4268f7/pyrsistent-0.15.6.tar.gz"
    sha256 "f3b280d030afb652f79d67c5586157c5c1355c9a58dfc7940566e28d28f3df1b"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/8d/c9/e5be955a117a1ac548cdd31e37e8fd7b02ce987f9655f5c7563c656d5dcb/PyYAML-5.2.tar.gz"
    sha256 "c0ee8eca2c582d29c3c2ec6e2c4f703d1b7f1fb10bc72317355a746057e7346c"
  end

  resource "ratelimiter" do
    url "https://files.pythonhosted.org/packages/5b/e0/b36010bddcf91444ff51179c076e4a09c513674a56758d7cfea4f6520e29/ratelimiter-1.2.0.post0.tar.gz"
    sha256 "5c395dcabdbbde2e5178ef3f89b568a3066454a6ddc223b76473dac22f89b4f7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/01/62/ddcf76d1d19885e8579acb1b1df26a852b03472c0e46d2b959a714c90608/requests-2.22.0.tar.gz"
    sha256 "11e007a8a2aa0323f5a921e9e6a2d7e4e67d9877e85773fba9ba6419025cbeb4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/3b/ba/e49102b3e8ffff644edded25394b2d22ebe3e645f3f6a8139129c4842ffe/smmap2-2.0.5.tar.gz"
    sha256 "29a9ffa0497e7f2be94ca0ed1ca1aa3cd4cf25a1f6b4f5f87f74b46ed91d609a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ad/fc/54d62fa4fc6e675678f9519e677dfc29b8964278d75333cf142892caf015/urllib3-1.25.7.tar.gz"
    sha256 "f3c5fd51747d450d4dcf6f923c81f78f811aab8205fda64b0aba34a4e48b0745"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/23/84/323c2415280bc4fc880ac5050dddfb3c8062c2552b34c2e512eb4aa68f79/wrapt-1.11.2.tar.gz"
    sha256 "565a021fd19419476b9362b05eeaa094178de64f8361e44468f9e9d7843901e1"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/57/dd/585d728479d97d25aeeb9aa470d36a4ad8d0ba5610f84e14770128ce6ff7/zipp-0.6.0.tar.gz"
    sha256 "3718b1cbcd963c7d4c5511a8240812904164b7f381b647143a89d3b98f9bcd8e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"Snakefile").write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    system "#{bin}/snakemake"
    assert_predicate testpath/"test.out", :exist?
  end
end
