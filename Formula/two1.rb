class ZerotierOneInstalled < Requirement
  def message; <<-EOS.undent
    Zerotier-One is required to install two1.

    You can install this with:
      brew cask install zerotier-one

    Or you can use an official installer from:
        https://www.zerotier.com/
    EOS
  end

  def satisfied?
    which "zerotier-cli"
  end

  def fatal?
    true
  end
end

class Two1 < Formula
  desc "21. Get bitcoin on any device. Earn bitcoin on every HTTP request."
  homepage "https://21.co"
  url "https://github.com/21dotco/two1-python/archive/3.8.2.tar.gz"
  sha256 "e5c83d56f80e16558e89fa8f47379f218f3f9069ae8830eb54f0afc9135f5fdc"

  depends_on :python3
  depends_on ZerotierOneInstalled

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/58/91/21d65af4899adbcb4158c8f0def8ce1a6d18ddcd8bbb3f5a3800f03b9308/arrow-0.8.0.tar.gz"
    sha256 "b210c17d6bb850011700b9f54c1ca0eaf8cbbd441f156f0cd292e1fbda84e7af"
  end

  resource "base58" do
    url "https://files.pythonhosted.org/packages/32/8c/9b8b1b8364a945fa1ed4308d650880a5eb77bd08c2086e32e1f608440ed8/base58-0.2.3.tar.gz"
    sha256 "a691b5d194617a3de401aa2ed8818f12f1e348e95524f74a9c67246b59368fff"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/7a/00/c14926d8232b36b08218067bcd5853caefb4737cda3f0a47437151344792/click-6.6.tar.gz"
    sha256 "cc6a19da8ebff6e7074f731447ef7e112bd23adf3de5c597cf9989f2fd8defe9"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/72/6b/037bd4c55909ee2a6e30e696ddb6e4197bd60585c8e6db23bfdcbebf6091/docker-py-1.8.0.tar.gz"
    sha256 "09ccd3522d86ec95c0659887d1da7b2761529020694efb0eeac87074cb4536c2"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/b0/56/48727b2a6c92b7e632180cf2c1411a0de7cf4f636b4f844c6c46f7edc86b/flake8-3.0.4.tar.gz"
    sha256 "b4c210c998f07d6ff24325dd91fbc011f2c37bcd6bf576b188de01d8656e970d"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/5a/f4/99abde815842bc6e97d5a7806ad51236630da14ca2f3b1fce94c0bb94d3d/future-0.15.2.tar.gz"
    sha256 "3d3b193f20ca62ba7d8782589922878820d0a023b885882deec830adbf639b97"
  end

  resource "jsonrpcclient" do
    url "https://files.pythonhosted.org/packages/5c/36/3ea7596389f8dde23a6130cefa7e65ba71b78a6375edc16bda0b1a168e20/jsonrpcclient-2.0.1.tar.gz"
    sha256 "c40b701e50f0a3e2f727cd473613a86751a9692f6439f1c919c68ebd7dd70b78"
  end

  resource "jsonrpcserver" do
    url "https://files.pythonhosted.org/packages/97/63/5ef4a38da2041d2ce3bf713660f2b171bbf3c7e4f6f3f523491639390a9e/jsonrpcserver-3.1.1.tar.gz"
    sha256 "17848c81bcae251b39f3af80486c10bed8b160486ac4695899df859e7fb1353d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/f1/b7/ff36d1a163079688633a776e1717b5459caccbb68973afab2aa8345ac40f/mccabe-0.5.2.tar.gz"
    sha256 "3473f06c8b757bbb5cdf295099bf64032e5f7d6fe0ec2f97ee9b23cb0a435aff"
  end

  resource "mnemonic" do
    url "https://files.pythonhosted.org/packages/78/33/9d5b4a8412227603526328c27060cc2c7175dc6770d670cd08243e584691/mnemonic-0.13.tar.gz"
    sha256 "9f58a9eba9995e4342b2b53a945b5cae9fd154aca8e940e0e2be8f61e037e62c"
  end

  resource "path.py" do
    url "https://files.pythonhosted.org/packages/85/80/d13c3e5058c14f0bf3c19e9596a70f1e805fcda8510531f338b9e96cc5c7/path.py-8.2.1.tar.gz"
    sha256 "c9ad2d462a7f8d7f6f6d2b89220bd50425221e399a4b8dfe5fa6725eb26fd708"
  end

  resource "pbkdf2" do
    url "https://files.pythonhosted.org/packages/02/c0/6a2376ae81beb82eda645a091684c0b0becb86b972def7849ea9066e3d5e/pbkdf2-1.3.tar.gz"
    sha256 "ac6397369f128212c43064a2b4878038dab78dab41875364554aaf2a684e6979"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d7/92/34c5810fa05e98082d141048110db97d2f98d318fa96f8202bf146ab79de/protobuf-3.0.0a3.tar.gz"
    sha256 "b61622de5048415bfd3f2d812ad64606438ac9e25009ae84191405fe58e522c1"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/f4/9a/8dfda23f36600dd701c6722316ba8a3ab4b990261f83e7d3ffc6dfedf7ef/py-1.4.31.tar.gz"
    sha256 "a6501963c725fc2554dabfece8ae9a8fb5e149c0ac0a42fd2b02c5c1c57fc114"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/63/31/6768a72cdca5dbd299ae798b690801e6c9c2f018332eec3c5fca79370dba/pyaes-1.6.0.tar.gz"
    sha256 "9cd5a54d914b1eebfb14fcb490315214b6a0304d9f1bb47e90d1d8e0b15ce92e"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/db/b1/9f798e745a4602ab40bf6a9174e1409dcdde6928cf800d3aab96a65b1bbf/pycodestyle-2.0.0.tar.gz"
    sha256 "37f0420b14630b0eaaf452978f3a6ea4816d787c3e6dcbba6fb255030adae2e7"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/54/80/6a641f832eb6c6a8f7e151e7087aff7a7c04dd8b4aa6134817942cdda1b6/pyflakes-1.2.3.tar.gz"
    sha256 "2e4a1b636d8809d8f0a69f341acf15b2e401a3221ede11be439911d23ce2139e"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/2b/05/e20806c99afaff43331f5fd8770bb346145303882f98ef3275fa1dd66f6d/pytest-3.0.2.tar.gz"
    sha256 "64d8937626dd2a4bc15ef0edd307d26636a72a3f3f9664c424d78e40efb1e339"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "sha256" do
    url "https://files.pythonhosted.org/packages/04/98/e2d70dc0af14a35ee62c5f6146120f8735e43e1de5daf633c61a2cdd8e67/sha256-0.1.tar.gz"
    sha256 "ed989b0bb3adcd01e8fef33bc8de17a70dde2661de448f13e9434f78ded1bb1b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/db/40/6ffc855c365769c454591ac30a25e9ea0b3e8c952a1259141f5b9878bd3d/tabulate-0.7.5.tar.gz"
    sha256 "9071aacbd97a9a915096c1aaf0dc684ac2672904cd876db5904085d6dac9810e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    %w[arrow base58 click docker-py flake8 funcsigs future jsonrpcclient jsonrpcserver jsonschema mccabe mnemonic path.py pbkdf2 pexpect protobuf ptyprocess py pyaes pycodestyle pyflakes pytest python-dateutil PyYAML requests sha256 six tabulate websocket-client].each do |r|
      resource(r).stage do
        system "python3", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "python3 -c 'import two1'"
    return true
  end
end
