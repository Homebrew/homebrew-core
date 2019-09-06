class Snakemake < Formula
  include Language::Python::Virtualenv

  desc "Pythonic workflow system"
  homepage "https://snakemake.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/58/70/daa0a380c14016b4510f6e039b5ee6c27125b66b3867a16933aa81471091/snakemake-5.5.3.tar.gz"
  sha256 "a598d8744fa1227316e2b6b8a3710c068c087957a431325c1e4e4a363dc6b1a8"
  head "https://bitbucket.org/snakemake/snakemake.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9de120998214525e45eee2fb3be36580c40ff2f99194808d31a042683b2cacd6" => :mojave
    sha256 "630399811f48eae6dbce87ae1876daadbacd5572833924ae06820a1abf97dd08" => :high_sierra
    sha256 "fbfe4c312c12026fbc49720090d971144da705c95d10f9f6f8c40725927aacb2" => :sierra
  end

  depends_on "python"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/cc/d9/931a24cc5394f19383fbbe3e1147a0291276afa43a0dc3ed0d6cd9fda813/attrs-19.1.0.tar.gz"
    sha256 "f0b870f674851ecbfbbbd364d6b5cbdff9dcedbc7f3f5e18a6891057f21fe399"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/c5/67/5d0548226bcc34468e23a0333978f0e23d28d0b3f0c71a151aef9c3f7680/certifi-2019.6.16.tar.gz"
    sha256 "945e3ba63a0b9f577b1395204e13c3a231f9bc0223888be653286534e5873695"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/55/ea/f0ade52790bcd687127a302b26c1663bf2e0f23210d5281dbfcd1dfcda28/ConfigArgParse-0.14.0.tar.gz"
    sha256 "2e2efe2be3f90577aca9415e32cb629aa2ecd92078adbe27b53a03e53ff12e91"
  end

  resource "datrie" do
    url "https://files.pythonhosted.org/packages/f5/a2/49d6db3af61eb139fb8fa2cdff90a4789e8255d227baf8f9a1ec945b4aac/datrie-0.8.tar.gz"
    sha256 "bdd5da6ba6a97e7cd96eef2e7441c8d2ef890d04ba42694a41c7dffa3aca680c"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "gitdb2" do
    url "https://files.pythonhosted.org/packages/c4/5c/579abccd59187eaf6b3c8a4a6ecd86fce1dfd818155bfe4c52ac28dca6b7/gitdb2-2.0.5.tar.gz"
    sha256 "83361131a1836661a155172932a13c08bda2db3674e4caa32368aa6eb02f38c2"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/4d/e8/98e06d3bc954e3c5b34e2a579ddf26255e762d21eb24fede458eff654c51/GitPython-2.1.11.tar.gz"
    sha256 "8237dc5bfd6f1366abeee5624111b9d6879393d84745a507de0fda86043b65a8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/1f/7f/a020327823b9c405ee6f85ab3053ff171e10801b19cfe55c78bb0b3810e7/jsonschema-3.0.1.tar.gz"
    sha256 "0c0a81564f181de3212efa2d17de1910f8732fa1b71c42266d983cd74304e20d"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/6c/ef/7781092174a42d0b57fb02a2eb23f78ebc8e588c9bd7455e1d1c7b1ea516/pyrsistent-0.15.3.tar.gz"
    sha256 "50cffebc87ca91b9d4be2dcc2e479272bcb466b5a0487b6c271f7ddea6917e14"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a3/65/837fefac7475963d1eccf4aa684c23b95aa6c1d033a2c5965ccb11e22623/PyYAML-5.1.1.tar.gz"
    sha256 "b4bb4d3f5e232425e25dda21c070ce05168a786ac9eda43768ab7f3ac2770955"
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
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "smmap2" do
    url "https://files.pythonhosted.org/packages/3b/ba/e49102b3e8ffff644edded25394b2d22ebe3e645f3f6a8139129c4842ffe/smmap2-2.0.5.tar.gz"
    sha256 "29a9ffa0497e7f2be94ca0ed1ca1aa3cd4cf25a1f6b4f5f87f74b46ed91d609a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4c/13/2386233f7ee40aa8444b47f7463338f3cbdf00c316627558784e3f542f07/urllib3-1.25.3.tar.gz"
    sha256 "dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/23/84/323c2415280bc4fc880ac5050dddfb3c8062c2552b34c2e512eb4aa68f79/wrapt-1.11.2.tar.gz"
    sha256 "565a021fd19419476b9362b05eeaa094178de64f8361e44468f9e9d7843901e1"
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
