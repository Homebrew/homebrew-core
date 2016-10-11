class Saltstack < Formula
  include Language::Python::Virtualenv

  desc "Dynamic infrastructure communication bus"
  homepage "http://www.saltstack.org"
  url "https://files.pythonhosted.org/packages/1d/75/b969c2495ae6ccbf8b76f6a121027f3ee8cfab9d9a1086e9ccf07d10deae/salt-2016.3.3.tar.gz"
  sha256 "5906038594f1b9b3ac41714774fbd78f0af80d2f3ffe1c1bf20308032d7d52b6"
  head "https://github.com/saltstack/salt.git", :branch => "develop", :shallow => false

  bottle do
    cellar :any
    sha256 "699ff488110e31e12bcc075eaaefe735fc5b2515021158f7fecd8ace82c08286" => :sierra
    sha256 "2e6a1bd9a2a9e291a100437209eaa5e2295c44d3f3b1b724b5f1d10b7c871dba" => :el_capitan
    sha256 "28de29e0eadbe4aba2307860337cb43f161d7f42aac590e9307ff8f94dfa52ad" => :yosemite
    sha256 "aeb6a3ebfe71e1ba3d83012158849ae704f557e9aebfc6a34f4337354dddb3d2" => :mavericks
  end

  depends_on "swig" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "zeromq"
  depends_on "libyaml"
  depends_on "openssl" # For M2Crypto

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "M2Crypto" do
    url "https://files.pythonhosted.org/packages/9c/58/7e8d8c04995a422c3744929721941c400af0a2a8b8633f129d92f313cfb8/M2Crypto-0.25.1.tar.gz"
    sha256 "ac303a1881307a51c85ee8b1d87844d9866ee823b4fdbc52f7e79187c2d9acef"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/75/5e/b84feba55e20f8da46ead76f14a3943c8cb722d40360702b2365b91dec00/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "backports_abc" do
    url "https://files.pythonhosted.org/packages/f5/d0/1d02695c0dd4f0cf01a35c03087c22338a4f72e24e2865791ebdb7a45eac/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/bf/88a3269c7c95fc94a2c581c4b1b3d3ec21af7a268d6a3a4e54578adccfd6/certifi-2016.8.8.tar.gz"
    sha256 "99864ed602d8a9d212e339b15ffa438895002eda7b7db20dca5309dac9605ae9"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/21/27/8a1d82041c7a2a51fcc73675875a5f9ea06c2663e02fcfeb708be1d081a0/msgpack-python-0.4.8.tar.gz"
    sha256 "1a2b19df0f03519ec7f19f826afb935b202d8979b0856c6fb3dc28955799f886"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/ab/3a/5826efd93ebbbdc33203f70c6ceebab1b58ac6cb1e1ab131cc6b990b4cfa/pyzmq-15.4.0.tar.gz"
    sha256 "9d1d69da7ee78dce8721a1617c7938ded1cd1df76a6c1abf19acebb1a5ccc2bf"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "singledispatch" do
    url "https://files.pythonhosted.org/packages/d9/e9/513ad8dc17210db12cb14f2d4d190d618fb87dd38814203ea71c87ba5b68/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/96/5d/ff472313e8f337d5acda5d56e6ea79a43583cc8771b34c85a1f458e197c3/tornado-4.4.1.tar.gz"
    sha256 "371d0cf3d56c47accc66116a77ad558d76eebaa8458a6b677af71ca606522146"
  end

  def resources
    super - [resource("M2Crypto")]
  end

  def install
    venv = virtualenv_install_with_resources
    resource("M2Crypto").stage do
      inreplace "setup.py", "self.openssl = '/usr'",
                            "self.openssl = '#{Formula["openssl"].opt_prefix}'"
      venv.pip_install Pathname.pwd
    end
    prefix.install libexec/"share" # man pages
    (etc/"saltstack").install (buildpath/"conf").children # sample config files
  end

  def caveats; <<-EOS.undent
    Sample configuration files have been placed in #{etc}/saltstack.
    Saltstack will not use these by default.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salt --version")
  end
end
