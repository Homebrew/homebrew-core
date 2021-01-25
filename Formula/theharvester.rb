class Theharvester < Formula
  include Language::Python::Virtualenv

  desc "Gather materials from public sources (for pen testers)"
  homepage "http://www.edge-security.com/theharvester.php"
  url "https://github.com/laramies/theHarvester/archive/3.2.2.tar.gz"
  sha256 "597b5fdfccf76a30258d56e9c62dffc56fdd78682f75f2ed5b62b5a703d633b4"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/laramies/theHarvester.git"

  bottle do
    cellar :any
    sha256 "9dc1561d8d8b808f883e5f738116f20b9f40da8e23831c6b839b669a38718301" => :big_sur
    sha256 "02ea573d0407250c3e25729bc4c727b75efd34131bd759f8971073611c3b644f" => :arm64_big_sur
    sha256 "180c2e46cd59537a9fb3941b45651227458b824180d1e2dca953ef0dfdb82414" => :catalina
    sha256 "dec2bf1a27212b9fab8afa967fded9c9b2b641a53b0f59b4118e93b863377471" => :mojave
  end

  depends_on "libyaml"
  depends_on "python@3.8"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/30/2e/b86ce168485b68d40c6a810838669deacf0abf41845c383659c2b613e69f/aiodns-2.0.0.tar.gz"
    sha256 "815fdef4607474295d68da46978a54481dd1e7be153c7d60f9e72773cd38d77d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/68/96/40a765d7d68028c5a6d169b2747ea3f4828ec91a358a63818d468380521c/aiohttp-3.7.3.tar.gz"
    sha256 "9c1a81af067e72261c9cbe33ea792893e83bc6aa987bfbd6fdc1e5e7b22777c4"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/40/fd/02713e9715d5bcb7cac7b95a6703c24dbe4787805535cb8aa892c67fe45b/aiosqlite-0.16.0.tar.gz"
    sha256 "d014ef07fbc523b2d195fc17cf35982285e3220eb73c1068d5df37b569950ea8"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/a1/78/aae1545aba6e87e23ecab8d212b58bb70e72164b67eb090b81bb17ad38e3/async-timeout-3.0.1.tar.gz"
    sha256 "0c3c816a028d47f659d6ff5c745cb2acf1f966da1fe5c19c77a70282b25f4c5f"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/6b/c3/d31704ae558dcca862e4ee8e8388f357af6c9d9acb0cad4ba0fbbd350d9a/beautifulsoup4-4.9.3.tar.gz"
    sha256 "84729e322ad1d5b4d25f805bfa05b902dd96450f43842c4e99067d5e1369eb25"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/66/6a/98e023b3d11537a5521902ac6b50db470c826c682be6a8c661549cb7717a/cffi-1.14.4.tar.gz"
    sha256 "1a465cbe98a7fd391d47dce4b8f7e5b921e6cd805ef421d04f5f66ba8f06086c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/78/c4/0c59bf329240981fd3a228ac809a82d00d4b147a82555eb4dddba2d041aa/gevent-20.9.0.tar.gz"
    sha256 "5f6d48051d336561ec08995431ee4d265ac723a64bba99cc58c3eb1a4d4f5c8d"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/72/0c/fd07c7674ad6eded937194b84d8453425c36c6ef118536907b0185624d82/greenlet-0.4.17.tar.gz"
    sha256 "41d8835c69a78de718e466dd0e6bfd4b46125f21a67c3ff6d76d8d8059868d6b"
  end

  resource "grequests" do
    url "https://files.pythonhosted.org/packages/09/80/14e6838bb38fcef41bca78fb4e1dc879315bb03a412e8ba1891a2c13ac55/grequests-0.6.0.tar.gz"
    sha256 "7dec890c6668e6755a1ea968565535867956639301268394d24df67b478df666"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1c/74/e8b46156f37ca56d10d895d4e8595aa2b344cff3c1fb3629ec97a8656ccb/multidict-5.1.0.tar.gz"
    sha256 "25b4e5f22d3a37ddf3effc0710ba692cfc792c2b9edfb9c05aefe823256e84d5"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "plotly" do
    url "https://files.pythonhosted.org/packages/f9/f8/e90124c04cfbcb97c5d434d59ff053ecfee0da008adb45a9cf548e4bf7de/plotly-4.12.0.tar.gz"
    sha256 "9ec2c9f4cceac7c595ebb77c98cbeb6566a97bef777508584d9bb7d9bcb8854c"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/4e/09/f49ef1c4b6a5ad50fc08a8acd015f1938594dd7a6b4a6a96d049d9bbec7d/pycares-3.1.1.tar.gz"
    sha256 "18dfd4fd300f570d6c4536c1d987b7b7673b2a9d14346592c5d6ed716df0d104"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "retrying" do
    url "https://files.pythonhosted.org/packages/44/ef/beae4b4ef80902f22e3af073397f079c96969c69b2c7d52a57ea9ae61c9d/retrying-1.3.3.tar.gz"
    sha256 "08c039560a6da2fe4f2c426d0766e284d3b736e355f8dd24b37367b0bb41973b"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/49/7f/2e1ec600f21b3f84372c1f56df600bc956e5201ac18321b45821051ac248/shodan-1.24.0.tar.gz"
    sha256 "0b5ec40c954cd48c4e3234e81ad92afdc68438f82ad392fed35b7097eb77b6dd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/3e/db/5ba900920642414333bdc3cb397075381d63eafc7e75c2373bbc560a9fa1/soupsieve-2.0.1.tar.gz"
    sha256 "a59dc181727e95d25f781f0eb4fd1825ff45590ec8ff49eadfd7f1a537cc0232"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/f5/be/716342325d6d6e05608e3a10e15f192f3723e454a25ce14bc9b9d1332772/texttable-1.6.3.tar.gz"
    sha256 "ce0faf21aa77d806bbff22b107cc22cce68dc9438f97a2df32c93e9afa4ce436"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/16/06/0f7367eafb692f73158e5c5cbca1aec798cdf78be5167f6415dd4205fa32/typing_extensions-3.7.4.3.tar.gz"
    sha256 "99d4073b617d30288f569d3f13d2bd7548c3a7e4c8de87db09a9d29bb3a4a60c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/84/2e/462e7a25b787d2b40cf6c9864a9e702f358349fc9cfb77e83c38acb73048/uvloop-0.14.0.tar.gz"
    sha256 "123ac9c0c7dd71464f58f1b4ee0bbd81285d96cdda8bc3519281b8973e3a461e"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/97/e7/af7219a0fe240e8ef6bb555341a63c43045c21ab0392b4435e754b716fa1/yarl-1.6.3.tar.gz"
    sha256 "8a9066529240171b68893d60dca86a763eae2139dd42f42106b03cf4b426bf10"
  end

  def install
    venv = virtualenv_create(libexec/"venv", "python3")
    venv.pip_install resources

    libexec.install Dir["*"]
    (libexec/"theHarvester.py").chmod 0755
    (bin/"theharvester").write_env_script("#{libexec}/theHarvester.py", PATH: "#{libexec}/venv/bin:$PATH")
  end

  test do
    (testpath/"proxies.yaml").write <<~EOS
      http:
      - ip:port
    EOS

    output = shell_output("#{bin}/theharvester -d brew.sh -l 1 -b google 2>&1")
    assert_match "docs.brew.sh:", output
  end
end
