class Molecule < Formula
  include Language::Python::Virtualenv

  desc "Automated testing for Ansible roles"
  homepage "https://molecule.readthedocs.io"
  url "https://files.pythonhosted.org/packages/8a/62/286d05e42e17c0ceec9bac4f8710e5d84e3e60bd923d296762e3168b49d7/molecule-1.17.3.tar.gz"
  sha256 "4a3433938bf77d2c9042632968a24af9190519bcf0747e434d6a69ec45aba347"

  depends_on :python
  depends_on "openssl@1.1"

  # Collect requirements from:
  #  molecule
  #  docker-py

  resource "ansible" do
    url "https://files.pythonhosted.org/packages/48/da/5e51cf931e4c7849ba698654877e2951ade8f842f28f0c904453a1d317d7/ansible-2.2.0.0.tar.gz"
    sha256 "d9f198d293394ce0f8ba802561b21368888e3301036a706b5584641b49408586"
  end

  resource "ansible-lint" do
    url "https://files.pythonhosted.org/packages/89/bf/adcd6d51659be3c1303f8637545b1d2f1419630d7bc068a2b92f0d5c11f0/ansible-lint-3.4.8.tar.gz"
    sha256 "8e851152140552668662afb88b0680cffef4941c9d05fca296e1d7de9da05836"
  end

  resource "anyconfig" do
    url "https://files.pythonhosted.org/packages/1a/c4/4aeb05181b0c9ab9f3bb0846dec5cccfa392dc3c593593bc2642749c1897/anyconfig-0.7.0.tar.gz"
    sha256 "b972257f81770c0f535917cd8a61a74542180d3a86290b30155e0912cc7a3558"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/54/db/76459c4dd3561bbe682619a5c576ff30c42e37c2e01900ed30a501957150/arrow-0.10.0.tar.gz"
    sha256 "805906f09445afc1f0fc80187db8fe07670e3b25cdafa09b8d8ac264a8c0c722"
  end

  resource "backports.ssl_match_hostname" do
    url "https://pypi.python.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/52/69/9ca055b887ccc841fa2d0265aa2599c9d63bc57d3d421dfcda874e0ad3ef/binaryornot-0.4.0.tar.gz"
    sha256 "ab0f387b28912ac9c300db843461359e2773da3b922ae378ab69b0d85b288ec8"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/7d/87/4e3a3f38b2f5c578ce44f8dc2aa053217de9f0b6d737739b0ddac38ed237/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/95/d9/c3336b6b5711c3ab9d1d3a80f1a3e2afeb9d8c02a7166462f6cc96570897/click-6.7.tar.gz"
    sha256 "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/f0/d0/21c6449df0ca9da74859edc40208b3a57df9aca7323118c913e58d442030/colorama-0.3.7.tar.gz"
    sha256 "e043c8d32527607223652021ff648fbb394d5e19cba9f1a698670b338c9d782b"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/7c/69/c2ce7e91c89dc073eb1aa74c0621c3eefbffe8216b3f9af9d3885265c01c/configparser-3.5.0.tar.gz"
    sha256 "5308b47021bc2340965c371f0f058cc6971a04502638d4244225c49d80db273a"
  end

  resource "cookiecutter" do
    url "https://files.pythonhosted.org/packages/d5/78/eb3cbda4f936a0a7d8feb5240706309ed7777a5249387b8c89916fff9d3a/cookiecutter-1.4.0.tar.gz"
    sha256 "0b4d52480f9acfc5d9435abffe9eae053f509ed9388470fc51e961345afc6bed"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/82/f7/d6dfd7595910a20a563a83a762bf79a253c4df71759c3b228accb3d7e5e4/cryptography-1.7.1.tar.gz"
    sha256 "953fef7d40a49a795f4d955c5ce4338abcec5dea822ed0414ed30348303fdb4c"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://pypi.python.org/packages/95/2e/3c99b8707a397153bc78870eb140c580628d7897276960da25d8a83c4719/docker-pycreds-0.2.1.tar.gz"
    sha256 "93833a2cf280b7d8abbe1b8121530413250c6cd4ffed2c1cf085f335262f7348"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/b0/56/48727b2a6c92b7e632180cf2c1411a0de7cf4f636b4f844c6c46f7edc86b/flake8-3.0.4.tar.gz"
    sha256 "b4c210c998f07d6ff24325dd91fbc011f2c37bcd6bf576b188de01d8656e970d"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/00/2b/8d082ddfed935f3608cc61140df6dcbf0edea1bc3ab52fb6c29ae3e81e85/future-0.16.0.tar.gz"
    sha256 "e39ced1ab767b5936646cedba8bcce582398233d6a627067d4c6a454c90cfedb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/94/fe/efb1cb6f505e1a560b3d080ae6b9fddc11e7c542d694ce4635c49b1ccdcb/idna-2.2.tar.gz"
    sha256 "0ac27740937d86850010e035c6a10a564158a5accddf1aa24df89b0309252426"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/bb/26/3b64955ff73f9e3155079b9ed31812afdfa5333b5c76387454d651ef593a/ipaddress-1.0.17.tar.gz"
    sha256 "3a21c5a15f433710aaa26f1ae174b615973a25182006ae7f9c26de151cd51716"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "jinja2-time" do
    url "https://files.pythonhosted.org/packages/de/7c/ee2f2014a2a0616ad3328e58e7dac879251babdb4cb796d770b5d32c469f/jinja2-time-0.2.0.tar.gz"
    sha256 "d14eaa4d315e7688daa4969f616f226614350c48730bfa1692d2caebd8c90d40"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/c9/0b/b66016d49fc1b24864743e388bc4fa7dcbb83c29553b867404fad5b5855d/mccabe-0.5.3.tar.gz"
    sha256 "16293af41e7242031afd73896fef6458f4cad38201d21e28f344fff50ae1c25e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "poyo" do
    url "https://files.pythonhosted.org/packages/7a/93/3f5e0a792de7470ffe730bdb6a3dc311b8f9734aa65598ad3825bbf48edf/poyo-0.4.0.tar.gz"
    sha256 "8a95d95193eb0838117cc8847257bf17248ef6d157aaa55ea5c20509a87388b8"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/93/bd/8a90834a287e0c1682eab8e20ada672e4f4cf7d5b99f2833ddbf31ed1a6d/py-1.4.32.tar.gz"
    sha256 "c4b89fd1ff1162375115608d01f77c38cca1d0f28f37fd718005e19b28be41a7"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/db/b1/9f798e745a4602ab40bf6a9174e1409dcdde6928cf800d3aab96a65b1bbf/pycodestyle-2.0.0.tar.gz"
    sha256 "37f0420b14630b0eaaf452978f3a6ea4816d787c3e6dcbba6fb255030adae2e7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
    sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/a8/87/b7ca49efe52d2b4169f2bfc49aa5e384173c4619ea8e635f123a0dac5b75/pytest-3.0.5.tar.gz"
    sha256 "4a003aa956f023ce91aa6e166b555e6f02a4b0aeb459ac61e14f64c0d39037fd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "python-vagrant" do
    url "https://files.pythonhosted.org/packages/c2/20/8fc3b9b24ab9d18ed146c235949fc8795ae0f17b1160e2e04a41cc8f72fb/python-vagrant-0.5.14.tar.gz"
    sha256 "b720788b9a5180d2789f0751968a628b53f83ea2097b31ba7877014424a398c8"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/5b/0b/34be574b1ec997247796e5d516f3a6b6509c4e064f2885a96ed885ce7579/requests-2.12.4.tar.gz"
    sha256 "ed98431a0631e309bb4b63c81d561c1654822cb103de1ac7b47e45c26be7ae34"
  end

  resource "sh" do
    url "https://files.pythonhosted.org/packages/39/ca/1db6ebefdde0a7b5fb639ebc0527d8aab1cdc6119a8e4ac7c1c0cc222ec5/sh-1.11.tar.gz"
    sha256 "590fb9b84abf8b1f560df92d73d87965f1e85c6b8330f8a5f6b336b36f0559a4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "testinfra" do
    url "https://files.pythonhosted.org/packages/03/da/5b0a3cf2903aa1ecb944292a14ce2f0f890ff5b502fe2c48f20815a72757/testinfra-1.4.5.tar.gz"
    sha256 "b1f8c164513bc6f850990bad3679e6516b06efef3450a038f05f3c67f4256d27"
  end

  resource "websocket-client" do
    url "https://pypi.python.org/packages/f4/06/5552e64fee863aa9decbb4e46dccc05fe730a36f49f0d6427398837297da/websocket_client-0.32.0.tar.gz"
    sha256 "cb3ab95617ed2098d24723e3ad04ed06c4fde661400b96daa1859af965bfe040"
  end

  resource "whichcraft" do
    url "https://files.pythonhosted.org/packages/6b/73/c38063b84519a2597c0a57e472d28970d2f8ad991fde18612ff3708fda0c/whichcraft-0.4.0.tar.gz"
    sha256 "e756d2d9f157ab8516e7e9849c1808c57162b3689734a588c9a134e2178049a9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # Test the Vagrant driver
    system bin/"molecule", "init", "--role", "foo-vagrant", "--driver", "vagrant", "--verifier", "testinfra"
    assert File.exist?(testpath/"foo-vagrant/molecule.yml"), "Failed to create 'foo-vagrant/molecule.yml' file!"
    assert File.exist?(testpath/"foo-vagrant/tests/test_default.py"), "Failed to create 'foo-vagrant/tests/test_default.py' file!"
    Dir.chdir("foo-vagrant") do
      system bin/"molecule", "list"
    end

    # Test the Docker driver
    system bin/"molecule", "init", "--role", "foo-docker", "--driver", "docker", "--verifier", "testinfra"
    assert File.exist?(testpath/"foo-docker/molecule.yml"), "Failed to create 'foo-docker/molecule.yml' file!"
    assert File.exist?(testpath/"foo-docker/tests/test_default.py"), "Failed to create 'foo-docker/tests/test_default.py' file!"
    Dir.chdir("foo-docker") do
      system bin/"molecule", "list"
    end
  end
end
